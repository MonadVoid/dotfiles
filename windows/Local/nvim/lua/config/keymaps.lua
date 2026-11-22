-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- For Terminal
vim.keymap.set("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Insert mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert with jk" })

-- Normal mode
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzz", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzz", { desc = "Previous search result centered" })

-- Visual mode
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Grug-far: Search & Replace (safe from LazyVim conflicts)
vim.keymap.set("n", "<leader>sw", function()
  require("grug-far").open({
    prefills = {
      search = vim.fn.expand("<cword>"),
      flags = "--word-regexp",
    },
  })
end, { desc = "Grug-far: Search word under cursor" })
