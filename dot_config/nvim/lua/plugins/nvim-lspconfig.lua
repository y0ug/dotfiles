return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- For Marksman:
      marksman = {
        autostart = false,
        MD013 = false,
        settings = {
          markdown = {
            validate = true,
            ignoredRules = { "MD013/line-length" }, -- Disable line length rule
          },
        },
      },
      -- For markdown-oxide:
      markdown_oxide = {
        autostart = false,
        settings = {
          markdown_oxide = {
            linting = {
              -- Disable line length rule
              disabled_rules = { "MD013/line-length" },
            },
          },
        },
      },
    },
  },
}
