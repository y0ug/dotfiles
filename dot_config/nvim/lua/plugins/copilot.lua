return {
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    opts = function()
      require("copilot.api").status = require("copilot.status")
    end,
  },
  { "CopilotC-Nvim/CopilotChat.nvim", opts = { model = "claude-3.7-sonnet-thought" } },
}
