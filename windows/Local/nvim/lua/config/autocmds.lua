-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd'
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Only change directory if we are opening a real file
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" or path:match("term://") or path:match("oil://") then
      return
    end
    local dir = vim.fn.fnamemodify(path, ":p:h")
    if vim.fn.isdirectory(dir) == 1 then
      vim.api.nvim_set_current_dir(dir)
    end
  end,
})
