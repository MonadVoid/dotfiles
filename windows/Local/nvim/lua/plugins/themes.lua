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

      if use_transparency then
        local function apply_transparency()
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

        -- Apply on startup and on theme switch
        apply_transparency()
        vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_transparency })
      end
    end,
  },
}
