-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
--
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
vim.opt.wildmenu = true
vim.opt.wildmode = "full"

vim.api.nvim_create_user_command("Cppath", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    -- Send to tmux buffer only for unnamed register operations
    if vim.v.event.regname == "" then
      vim.fn.system('tmux set-buffer "' .. vim.fn.escape(vim.fn.getreg('"'), '"\\') .. '"')
    end
  end,
})
