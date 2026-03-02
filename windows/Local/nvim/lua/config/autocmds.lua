-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Format when leaving insert mode (like VS Code-ish)
-- vim.api.nvim_create_autocmd("InsertLeave", {
--   callback = function()
--     -- Only format if autoformat is enabled
--     if require("lazyvim.util").format.enabled() then
--       require("conform").format({ async = false, lsp_fallback = true })
--     end
--   end,
-- })

-- Helper to format the current line only (very stable)
local function format_line()
  local supported_ft = { "cpp", "c", "cs", "java" }
  if vim.tbl_contains(supported_ft, vim.bo.filetype) then
    local line = vim.api.nvim_win_get_cursor(0)[1]
    require("conform").format({
      bufnr = 0,
      -- This ensures we only fix the line we just finished
      range = {
        ["start"] = { line, 0 },
        ["end"] = { line, 0 },
      },
      lsp_fallback = true,
      async = true,
    })
  end
end

-- Trigger only on Semicolon
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "c", "cs", "java" },
  callback = function(args)
    vim.keymap.set("i", ";", function()
      -- 1. Insert the semicolon
      vim.api.nvim_feedkeys(";", "n", true)
      -- 2. Schedule the line-only format
      vim.schedule(format_line)
    end, { buffer = args.buf, desc = "VS-Style Line Format" })
  end,
})

-- local function transparent_bg()
--   local highlights = {
--     "Normal",
--     "NormalFloat",
--     "FloatBorder",
--     "SignColumn",
--     "TelescopeNormal",
--     "TelescopeBorder",
--     "NvimTreeNormal",
--     "NeoTreeNormal",
--     "StatusLine", -- Added for that full NvChad look
--   }
--   for _, hl in ipairs(highlights) do
--     vim.api.nvim_set_hl(0, hl, { bg = "none", ctermbg = "none" })
--   end
-- end
--
-- -- Create an autogroup to keep things clean
-- local trans_group = vim.api.nvim_create_augroup("TransparentGroup", { clear = true })
--
-- -- Run when switching themes
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   group = trans_group,
--   pattern = "*",
--   callback = transparent_bg,
-- })
--
-- -- Run on startup with a tiny delay (50ms) to beat the theme loader
-- vim.api.nvim_create_autocmd("VimEnter", {
--   group = trans_group,
--   callback = function()
--     vim.defer_fn(transparent_bg, 50)
--   end,
-- })
