return {
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "buffer", "snippets" },
        --   keymap = {
        --     preset = "default",
        --    },
        --
        per_filetype = {
          markdown = { "lsp", "path", "buffer" },
          codecompanion = { "codecompanion" },
          -- svelte = { "path" },
        },
        providers = {
          copilot = {
            enabled = function()
              return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
            end,
          },
          cmdline = { enabled = true },
        },
      },
    },
  },
}
