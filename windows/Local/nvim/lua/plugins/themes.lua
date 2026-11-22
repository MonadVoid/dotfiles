-- SET THIS TO true OR false
local use_transparency = true

return {
  -- 1. Your Theme List (Configured with the variable)
  { "catppuccin/nvim", name = "catppuccin", opts = { transparent_background = use_transparency } },
  { "folke/tokyonight.nvim", opts = { transparent = use_transparency } },
  { "navarasu/onedark.nvim", opts = { transparent = use_transparency } },
  { "rebelot/kanagawa.nvim", opts = { transparent = use_transparency } },
  {
    "Mofiqul/dracula.nvim",
    config = function()
      if use_transparency then
        vim.g.dracula_transparent_bg = 1
      end
    end,
  },
  { "EdenEast/nightfox.nvim", opts = { options = { transparent = use_transparency } } },
  { "Shatur/neovim-ayu" },
  { "rose-pine/neovim", name = "rose-pine", opts = { styles = { transparency = use_transparency } } },

  -- 2. The LazyVim Core Config
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
    config = function(_, opts)
      require("lazyvim.config").setup(opts)

      -- Senior Approach: Unified UI Override function
      local function apply_ui_overrides()
        -- 1. Handle Transparency if enabled
        if use_transparency then
          local groups = {
            "Normal",
            "NormalFloat",
            "NormalNC",
            "SignColumn",
            "StatusLine",
            "NeoTreeNormal",
            "NoiceCmdline",
            "MsgArea",
          }
          for _, group in ipairs(groups) do
            vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
          end
        end

        -- 2. Fix Search Highlight Colors globally across ALL themes
        -- 'Search' handles all found instances. 'CurSearch' highlights the specific hit your cursor is on.
        -- Beautiful balance of visibility and restraint
        vim.api.nvim_set_hl(0, "Search", { bg = "#61afef", fg = "#000000" })    -- Muted frost background, light blue text
        vim.api.nvim_set_hl(0, "CurSearch", { bg = "#e1acff", fg = "#000000" }) -- Bright focused match

       -- Perfect match for Dracula, TokyoNight, and Catppuccin
        -- vim.api.nvim_set_hl(0, "Search", { bg = "#e1acff", fg = "#000000" })   -- Readable lavender text on dark purple
        -- vim.api.nvim_set_hl(0, "CurSearch", { bg = "#ff79c6", fg = "#000000"}) -- PURE BLACK text on hot pink

        -- Senior pick for pure transparency: No background blocks on standard search results
        -- vim.api.nvim_set_hl(0, "Search", { bg = "NONE", fg = "#61afef", underline = true }) 
        -- vim.api.nvim_set_hl(0, "CurSearch", { bg = "#61afef", fg = "#282c34", bold = true })
      end

-- Apply on startup and hook into Neovim's theme-change lifecycle
      apply_ui_overrides()

      -- Senior Best Practice: Group the autocommand to prevent duplication/memory leaks on reload
      local ui_group = vim.api.nvim_create_augroup("LazyVimUIOverrides", { clear = true })
      
      vim.api.nvim_create_autocmd("ColorScheme", { 
        group = ui_group,
        desc = "Enforce custom transparency and search highlights globally",
        callback = apply_ui_overrides 
      })
    end,
  },
}
