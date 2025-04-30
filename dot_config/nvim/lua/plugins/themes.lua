return {
  { "EdenEast/nightfox.nvim" },
  { "catppuccin/nvim" },
  { "ellisonleao/gruvbox.nvim", opts = { contrast = "hard" } },
  {
    "rockyzhang24/arctic.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    name = "arctic",
    branch = "main",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme arctic")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "artic",
    },
  },
}
