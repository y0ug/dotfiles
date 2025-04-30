return {
  {
    "folke/noice.nvim",
    opts = function()
      return {
        presets = {
          bottom_search = true,
          command_palette = false,
          long_message_to_split = true,
          inc_rename = true,
          cmdline_output_to_split = false,
          lsp_doc_border = true,
        },
        messages = {
          enabled = true,
          view = "notify",
          view_error = "notify",
          view_warn = "notify",
          view_history = "messages",
          view_search = "virtualtext",
        },
        cmdline = {
          -- enabled = false,
          -- view = "cmdline",
          presets = { command_palette = true }, -- tab completions for commandline don't pop-up at top
        },
        popupmenu = {
          -- enabled = true,
        },
        last = {
          view = "split",
        },
      }
    end,
  },
}
