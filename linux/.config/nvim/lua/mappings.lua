require "nvchad.mappings"

-- add yours here
local map = vim.keymap.set
local harpoon = require "harpoon"

-- General mappings
--map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Debugging (DAP)
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle Breakpoint" })
map("n", "<leader>dr", "<cmd>DapContinue<CR>", { desc = "Start/Continue Debugger" })
map("n", "<leader>do", "<cmd>DapStepOver<CR>", { desc = "Step Over" })
map("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "Step Into" })
map("n", "<leader>du", "<cmd>DapStepOut<CR>", { desc = "Step Out" })
map("n", "<leader>dx", "<cmd>DapTerminate<CR>", { desc = "Terminate Debugger" })

-- Harpoon keybindings (QWERTY-friendly, <leader>m prefix)
map("n", "<leader>ma", function()
  harpoon:list():add()
end, { desc = "Harpoon: Add file" })
map("n", "<leader>mc", function()
  harpoon:list():clear()
end, { desc = "Harpoon: Clear all marks" })
map("n", "<leader>mm", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Toggle menu" })
map("n", "<leader>m1", function()
  harpoon:list():select(1)
end, { desc = "Harpoon: Go to mark 1" })
map("n", "<leader>m2", function()
  harpoon:list():select(2)
end, { desc = "Harpoon: Go to mark 2" })
map("n", "<leader>m3", function()
  harpoon:list():select(3)
end, { desc = "Harpoon: Go to mark 3" })
map("n", "<leader>m4", function()
  harpoon:list():select(4)
end, { desc = "Harpoon: Go to mark 4" })
map("n", "<leader>mp", function()
  harpoon:list():prev()
end, { desc = "Harpoon: Previous mark" })
map("n", "<leader>mn", function()
  harpoon:list():next()
end, { desc = "Harpoon: Next mark" })
map("n", "<leader>fm", "<cmd>Telescope harpoon marks<CR>", { desc = "Harpoon: Find marks" })

-- For custom telescope ui (optional)
-- map("n", "<leader>fm", function() require("configs.harpoon").toggle_telescope(harpoon:list()) end, { desc "Harpoon: Find marks" })
