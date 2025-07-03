vim.g.snacks_animate = false
local include = {
  ".github",
  ".env*",
}

local excluded = {
  "node_modules/",
  "dist/",
  ".next/",
  ".vite/",
  ".git/",
  ".gitlab/",
  "build/",
  "target/",

  "package-lock.json",
  "pnpm-lock.yaml",
  "yarn.lock",
  ".pytest_cache",
  ".ruff_cache",
  ".aider.tags.cache.*/",
  ".devenv/",
  "devenv.lock",
  "uv.lock",
  ".direnv/",
  ".devenv",
  "__pycache__",
  ".devenv.flake.nix",
}
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      image = {
        -- your image configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      scope = {},
      ---@class snacks.picker.Config
      picker = {
        -- show hidden files like .env
        -- hidden = true,
        -- show files ignored by git like node_modules
        -- ignored = true,

        include = include,
        -- exclude = excluded,
        ---@class snacks.picker.matcher.Config
        matcher = {
          fuzzy = true,
          smartcase = true,
          file_pos = true,

          cwd_bonus = true,
          ignorecase = true,
          filename_bonus = true,
          frequency = true,
          history_bonus = false,
        },
      },
    },
    keys = {
      {
        "<leader>s",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      {
        "<leader>fz",
        function()
          Snacks.picker.zoxide()
        end,
        desc = "Zoxide",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        "<leader>gF",
        function()
          Snacks.picker.git_log_file({
            finder = "git_log",
            format = "git_log",
            preview = "git_show",
            current_file = true,
            follow = true,
            confirm = "git_show",
            sort = { fields = { "score:desc", "idx" } },
          })
        end,
        desc = "Git Current File Show",
      },
    },
  },
}
