return {
  {
    "zk-org/zk-nvim",
    opts = {
      picker = "snacks_picker",
    },
    keys = {
      { "<leader>zo", ":ZkNotes<cr>", desc = "open notes" },
      { "<leader>zn", ":ZkNew<cr>", desc = "create new notes" },
      { "<leader>zb", ":ZkBacklinks<cr>", desc = "show back links" },
      { "<leader>zl", ":ZkLinks<cr>", desc = "show links" },
      { "<leader>zt", ":ZkTags<cr>", desc = "show tags" },
    },

    config = function(_, opts)
      require("zk").setup(opts)
    end,
  },
}
