-- return {
--   "MagicDuck/grug-far.nvim",
--   dependencies = { "nvim-lua/plenary.nvim" },
--   config = function()
--     require("grug-far").setup({
--       transient = true,
--       windowCreationStrategy = "split",
--
--       keymaps = {
--         close = { n = "q" },
--         replace = { n = "<localleader>r" },
--       },
--     })
--   end,
-- }

return {
  "MagicDuck/grug-far.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("grug-far").setup({
      transient = true,
      windowCreationCommand = "botright split",

      -- Reuses the previous window (the upper pane) to open files
      openTargetWindow = {
        preferredLocation = "prev",
      },

      keymaps = {
        close = { n = "q" },
        replace = { n = "<localleader>r" },
      },
    })
  end,
}
