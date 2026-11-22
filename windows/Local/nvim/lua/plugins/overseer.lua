return {
  {
    "stevearc/overseer.nvim",
    lazy = true,
    cmd = { "OverseerRun", "OverseerToggle", "OverseerOpen", "OverseerRunLast" },
    keys = {
      { "<leader>o", group = "+compile" },
      { "<leader>oo", desc = "Select Task Menu" },
      { "<leader>or", desc = "Recompile Last Task" },
      { "<leader>oc", desc = "Toggle Output Panel" },
    },
    config = function()
      local overseer = require("overseer")

      overseer.setup({
        task_list = {
          direction = "bottom",
          min_height = 15,
          max_height = 30,
          default_detail = 1,
        },
        -- Senior Design: Load standard system shells AND the native VS Code parser
        templates = { "builtin", "vscode" },
      })

      -- Central Task Runner (Universally scans the project workspace)
      vim.keymap.set("n", "<leader>oo", function()
        -- Directly runs Overseer's optimized task scanning window
        -- If a .vscode/tasks.json exists, its targets will cleanly populate this menu
        vim.cmd("OverseerRun")
      end, { desc = "Select Task Menu" })

      -- Asynchronous Recompile Last Execution
      vim.keymap.set("n", "<leader>or", "<cmd>OverseerRunLast<CR>", { desc = "Recompile Last Task" })

      -- Toggle output panel
      vim.keymap.set("n", "<leader>oc", "<cmd>OverseerToggle<CR>", { desc = "Toggle Output Panel" })
    end,
  },
}
