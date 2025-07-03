return {
  "alexghergh/nvim-tmux-navigation",
  enabled = true,
  cmd = {
    "NvimTmuxNavigateLeft",
    "NvimTmuxNavigateDown",
    "NvimTmuxNavigateUp",
    "NvimTmuxNavigateRight",
    "NvimTmuxNavigateNext",
    "NvimTmuxNavigateLastActive",
  },
  keys = {
    { "<c-h>", "<cmd>NvimTmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd>NvimTmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd>NvimTmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd>NvimTmuxNavigateRight<cr>" },
    { "<c-tab>", "<cmd>NvimTmuxNavigateLastActive<cr>" },
  },
  config = function()
    local tmux_nav = require("nvim-tmux-navigation")
    tmux_nav.setup({ disable_when_zoomed = false })
  end,
}
