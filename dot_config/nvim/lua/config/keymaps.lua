-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  vim.snippet.jump(1)
end)
vim.keymap.set({ "i", "s" }, "<c-i>", function()
  vim.snippet.jump(-1)
end)

-- vim.keymap.set({ "i", "x", "v", "n" }, "<f1>", function() end)
--
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
-- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
-- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
-- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })

-- Move Lines disable hack for tmux/neovim bug
vim.keymap.del("i", "<A-k>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("n", "<A-j>")
vim.keymap.del("v", "<A-k>")
vim.keymap.del("v", "<A-j>")
-- map("n", "<A-j>", "<esc>j", { desc = "Move down" })
-- map("i", "<A-k>", "<esc>gk", { desc = "Move up" })
-- map("i", "<A-j>", "<esc>gj", { desc = "Move down" })
-- map("v", "<A-k>", "<esc>gk", { desc = "Move up" })
-- map("v", "<A-j>", "<esc>gj", { desc = "Move down" })
--
vim.keymap.set("i", "<C-BS>", "<C-w>")
vim.keymap.set("c", "<C-BS>", "<C-w>")
vim.keymap.set("i", "<C-H>", "<C-w>") -- using Ctrl+Backspace delete a word. ref:https://www.reddit.com/r/neovim/comments/prp8zw/using_ctrlbackspace_in_neovim/
vim.keymap.set("c", "<C-H>", "<C-w>")

-- stop accidentally pressing q
vim.keymap.set("n", "q", "<nop>", { noremap = true })
vim.keymap.set("n", "Q", "q", { noremap = true, desc = "Record macro" })
vim.keymap.set("n", "<M-q>", "Q", { noremap = true, desc = "Replay last register macro" })

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
--
-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
-- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
-- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
-- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })

-- vim.keymap.set("n", "h", "<nop>")
-- vim.keymap.set("n", "j", "<nop>")
-- vim.keymap.set("n", "k", "<nop>")
-- vim.keymap.set("n", "l", "<nop>")
vim.keymap.set("n", "<leader>fl", ":luafile %<CR>", { noremap = true, silent = true, desc = "Reload current file" })
