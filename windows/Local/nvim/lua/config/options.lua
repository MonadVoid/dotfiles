-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.pumblend = 0

-- This fixes "tearing" or weird background colors in Windows Terminal
if vim.fn.has("win32") == 1 then
  vim.g.neovide_transparency = 0.8
end

local opt = vim.opt

opt.shiftwidth = 4 -- Size of an indent
opt.tabstop = 4 -- Number of spaces tabs count for
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Insert indents automatically
