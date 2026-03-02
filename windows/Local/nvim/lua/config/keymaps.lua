-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Insert mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert with jk" })

-- Normal mode
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzz", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzz", { desc = "Previous search result centered" })

-- Visual mode
vim.keymap.set("x", "<leader>p", [["_dP]])
