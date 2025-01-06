return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>G"] = { name = "+git-auto" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Function to check if ANTHROPIC_API_KEY is set
      local function check_api_key()
        local api_key = vim.fn.getenv("ANTHROPIC_API_KEY")
        if api_key == vim.NIL or api_key == "" then
          vim.notify("Error: ANTHROPIC_API_KEY environment variable is not set", vim.log.levels.ERROR)
          return false
        end
        return true
      end

      -- Function to check if ai-commit-msg.sh exists in PATH
      local function check_commit_script()
        local handle = io.popen("command -v ai-commit-msg.sh")
        local result = handle:read("*a")
        handle:close()
        if result == "" then
          vim.notify("Error: ai-commit-msg.sh not found in PATH", vim.log.levels.ERROR)
          return false
        end
        return true
      end

      -- Function to check if there are staged changes
      local function check_staged_changes()
        -- local handle = io.popen("git diff --cached --quiet 2>/dev/null || echo 'has_changes'")
        local handle = io.popen("git diff --quiet 2>/dev/null || echo 'has_changes'")
        local result = handle:read("*a")
        handle:close()
        if result:match("has_changes") then
          return true
        else
          vim.notify("Error: No staged changes found. Stage your changes with 'git add' first.", vim.log.levels.ERROR)
          return false
        end
      end

      -- Function to execute git commands
      local function execute_git_commands()
        -- Add all changes
        local add_handle = io.popen("git add . 2>&1")
        local add_result = add_handle:read("*a")
        add_handle:close()
        if add_result ~= "" then
          vim.notify("Error during git add: " .. add_result, vim.log.levels.ERROR)
          return false
        end

        -- Generate commit message
        local msg_handle = io.popen("ai-commit-msg.sh 2>&1")
        local commit_msg = msg_handle:read("*a")
        msg_handle:close()
        if commit_msg == "" then
          vim.notify("Error: Failed to generate commit message", vim.log.levels.ERROR)
          return false
        end

        -- Commit changes
        local commit_handle = io.popen(string.format('git commit -m "%s" 2>&1', commit_msg))
        local commit_result = commit_handle:read("*a")
        commit_handle:close()
        if commit_result:match("error:") then
          vim.notify("Error during commit: " .. commit_result, vim.log.levels.ERROR)
          return false
        end

        -- Push changes
        local push_handle = io.popen("git push 2>&1")
        local push_result = push_handle:read("*a")
        push_handle:close()
        if push_result:match("error:") then
          vim.notify("Error during push: " .. push_result, vim.log.levels.ERROR)
          return false
        end

        vim.notify("Successfully committed and pushed changes:\n" .. commit_msg, vim.log.levels.INFO)
        return true
      end

      vim.api.nvim_create_user_command("GitAutoCommit", function()
        -- Check all prerequisites
        if not check_api_key() or not check_commit_script() or not check_staged_changes() then
          return
        end

        -- Execute git commands
        execute_git_commands()
      end, {})

      -- Add the keymapping
      vim.keymap.set("n", "<leader>Ga", ":GitAutoCommit<CR>", {
        desc = "Auto commit and push",
        silent = true,
      })
    end,
  },
}
