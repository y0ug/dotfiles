return {
  {
    "stevearc/conform.nvim",
    optional = true, -- Ensure this plugin is optional
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt", "golines" },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "golines" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        gopls = {
          settings = {
            gopls = {
              usePlaceholders = false,
              completeUnimported = true,
            },
          },
        },
      },
    },
  },
}
