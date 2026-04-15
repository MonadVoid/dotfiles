return {
  "MagicDuck/grug-far.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("grug-far").setup({
      transient = true,
      windowCreationStrategy = "split",

      keymaps = {
        close = { n = "q" },
        replace = { n = "<localleader>r" },
      },
    })
  end,
}
