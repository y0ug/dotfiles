return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "shellcheck" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          filetypes = { "sh", "zsh" },
        },
      },
    },
  },
}
