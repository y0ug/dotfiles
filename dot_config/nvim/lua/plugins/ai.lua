return {
  {
    "joshuavial/aider.nvim",
    enable = false,
    opts = {
      -- your configuration comes here
      -- if you don't want to use the default settings
      auto_manage_context = true, -- automatically manage buffer context
      default_bindings = true, -- use default <leader>A keybindings
      debug = false, -- enable debug logging
    },
  },
  {
    "YounesElhjouji/nvim-copy",
    lazy = true, -- ensures the plugin is loaded on startup
    commit = "529fe48",
    config = function()
      require("nvim_copy").setup({
        ignore = {
          "*node_modules/*",
          "*__pycache__/*",
          "*.git/*",
          "*dist/*",
          "*build/*",
          "*.log",
        },
      })

      -- Optional key mappings:
      vim.api.nvim_set_keymap("n", "<leader>cb", ":CopyBuffersToClipboard<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    lazy = true,
    opts = {
      strategies = {
        -- Change the default chat adapter
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>ac",
        function()
          local mode = vim.fn.mode()
          if mode == "v" or mode == "V" then
            -- Visual mode: Use '<,'> range to pass the selection
            vim.cmd("'<,'>CodeCompanionChat")
          else
            -- Normal mode: Just open chat
            vim.cmd("CodeCompanionChat")
          end
        end,
        mode = { "n", "v" },
        desc = "Start AI chat with selection",
      },
      {
        "<leader>aa",
        function()
          local mode = vim.fn.mode()
          if mode == "v" or mode == "V" or mode == "" then
            -- Visual mode: Use '<,'> range to pass the selection
            vim.cmd("'<,'>CodeCompanionAction")
          else
            -- Normal mode: Just open action panel
            vim.cmd("CodeCompanionAction")
          end
        end,
        mode = { "n", "v" },
        desc = "Start AI action with selection",
      },
      {
        "<leader>aw",
        "<cmd>CodeCompanionChat Toggle<CR>",
        mode = { "n", "v" },
        desc = "Open the latest chat buffer",
      },
    },
  },
}
