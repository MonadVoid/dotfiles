return {
  "akinsho/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("flutter-tools").setup({
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        highlight = "Comment",
        prefix = "// ",
      },
      dev_log = {
        enabled = true,
        open_cmd = "botright 15split",
      },
      lsp = {
        timeout = 60, -- Prevents timeout during workspace indexing
      },
    })
  end,
}

