return {
  -- Import defaults (handles menu width and auto-save)
  { import = "lazyvim.plugins.extras.editor.harpoon2" },

  -- Register the group name/icon for the main leader menu
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, {
        -- The "Senior" v3 way: Use icon as a table to provide a specific highlight group
        { "<leader>m", group = "harpoon", icon = { icon = "󰀱 ", color = "green" } },
      })
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-telescope/telescope.nvim" },
    -- Ensure the extension is loaded after harpoon is set up
    config = function(_, opts)
      require("harpoon"):setup(opts)
      require("telescope").load_extension("harpoon")
    end,
    keys = function()
      local harpoon = require("harpoon")

      local keys = {
        -- Disable LazyVim default keys
        { "<leader>H", false },
        { "<leader>h", false },

        -- Core Functions
        {
          "<leader>ma",
          function()
            harpoon:list():add()
          end,
          desc = "󰀱 Harpoon: Add File",
        },
        {
          "<leader>mc",
          function()
            harpoon:list():clear()
          end,
          desc = "󰀱 Harpoon: Clear All",
        },
        {
          "<leader>mm",
          function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "󰀱 Harpoon: Menu",
        },

        -- Using the official Telescope extension for colored, high-quality previews
        { "<leader>me", "<cmd>Telescope harpoon marks<cr>", desc = "󰀱 Harpoon: Telescope Preview" },

        {
          "<leader>mn",
          function()
            harpoon:list():next()
          end,
          desc = "󰀱 Harpoon Next",
        },
        {
          "<leader>mp",
          function()
            harpoon:list():prev()
          end,
          desc = "󰀱 Harpoon Prev",
        },
      }

      return keys
    end,
  },
}
