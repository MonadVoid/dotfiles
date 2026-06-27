-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- This fixes "tearing" or weird background colors in Windows Terminal
if vim.fn.has("win32") == 1 then
  vim.g.neovide_transparency = 0.8
end

vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.guicursor = "n:block,i-v-c:block-blinkon100-blinkoff100"

local opt = vim.opt

opt.shiftwidth = 4 -- Size of an indent
opt.tabstop = 4 -- Number of spaces tabs count for
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = false -- Insert indents automatically

-- Fix Windows backslash issues with LSP and paths
if vim.fn.has("win32") == 1 then
  vim.opt.shellslash = true
end

-- Fix: Prevent hitting 'o' or 'Enter' from automatically creating new comment lines
-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function()
--     vim.opt.formatoptions:remove({ "c", "r", "o" })
--   end,
-- })

-- Stop comment duplication and copy the exact line indentation
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "c", "cpp" },
--   callback = function()
--     vim.opt_local.formatoptions:remove({ "c", "r", "o" })
--     vim.opt_local.cindent = false
--     vim.opt_local.smartindent = true
--     vim.opt_local.autoindent = true
--     -- vim.opt_local.indentexpr = ""
--   end,
-- })
