return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        ["<leader>fC"] = {
          function()
            local current_file = vim.fn.expand("%:p:h")
            vim.cmd("cd " .. current_file)
            vim.notify("Working directory changed to: " .. current_file)
          end,
          "Change Working Directory to Current File",
        },
      },
    },
  },
}
