return {
  {
    "saghen/blink.cmp",
    opts = {
      cmdline = {
        keymap = { preset = "inherit" },
        completion = { menu = { auto_show = true } },
      },
      keymap = {
        preset = "default",
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "buffer", "snippets" },
        --
        per_filetype = {
          markdown = { "lsp", "path", "buffer" },
          codecompanion = { "codecompanion" },
          -- svelte = { "path" },
        },
        providers = {
          -- copilot = {
          --   enabled = function()
          --     return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
          --   end,
          -- },
          cmdline = { enabled = true },
        },
      },
    },
  },
}
