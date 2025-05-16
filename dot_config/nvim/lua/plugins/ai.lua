return {
  {
    "joshuavial/aider.nvim",
    enabled = false,
    opts = {
      auto_manage_context = true, -- automatically manage buffer context
      default_bindings = true, -- use default <leader>A keybindings
      debug = false, -- enable debug logging
    },
  },
  {
    "monkoose/neocodeium",
    enabled = false,
    event = "VeryLazy",
    opts = {
      completion = {
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "default"
          end,
        },
      },
    },
    config = function(_, opts)
      local neocodeium = require("neocodeium")
      local blink = require("blink.cmp")
      neocodeium.setup(opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          neocodeium.clear()
        end,
      })

      neocodeium.setup({
        filter = function()
          return not blink.is_visible()
        end,
      })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    lazy = true,
    opts = {
      display = {
        action_palette = {
          provider = "snacks",
        },
      },
      strategies = {
        -- Change the default chat adapter
        chat = {
          adapter = "anthropic",
          slash_commands = {
            ["buffer"] = { opts = { provider = "snacks" } },
            ["file"] = { opts = { provider = "snacks" } },
          },
        },
        inline = {
          adapter = "anthropic",
          keymaps = {
            accept_change = {
              modes = { n = "ga" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "gR" },
              description = "Reject the suggested change",
            },
          },
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
            make_vars = true, -- make chat #variables from MCP server resources
            make_slash_commands = true, -- make /slash_commands from MCP server prompts
          },
        },
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "sc",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 0,
            -- Picker interface ("telescope" or "snacks" or "default")
            picker = "telescope",
            -- Automatically generate titles for new chats
            auto_generate_title = true,
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,
          },
        },
      },
    },
    dependencies = {
      "ravitemer/mcphub.nvim",
      "ravitemer/codecompanion-history.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>ac", ":CodeCompanionChat Toggle<cr>", desc = "codecompanion chat", mode = { "v", "n" } },
      { "<leader>as", "<cmd>CodeCompanion<cr>", desc = "codecompanion selection", mode = { "v" } },
      { "<leader>aa", ":CodeCompanionActions<cr>", desc = "codecompanion actions", mode = { "v", "n" } },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    cmd = "MCPHub", -- lazy load
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    keys = {
      { "<leader>ah", ":MCPHub<cr>", desc = "mcpp hub" },
    },
    -- build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    build = "bundled_build.lua", -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
    opts = {
      auto_approve = false, -- Auto approve mcp tool calls
      use_bundled_binary = true, -- Use bundled mcp-hub binary
    },
    config = function(_, opts)
      require("mcphub").setup(opts)
      -- local component = require("mcphub.extensions.lualine")
      -- require("util.lualine").inject_component({ "sections", "lualine_x" }, 1, component)
    end,
  },
}
