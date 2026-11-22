-- return {
--   "ej-shafran/compile-mode.nvim",
--   version = "^5.0.0",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     { "m00qek/baleia.nvim", tag = "v1.3.0" },
--   },
--   config = function()
--     -- Set configuration options on the global table expected by the plugin
--     vim.g.compile_mode = {
--       -- Define static templates per filetype; the plugin engine parses these
--       default_command = {
--         python = 'python "%"',
--         cpp = 'g++ -std=c++20 "%" -o "%:r.exe" && "%:r.exe"',
--         c = 'g++ -std=c++20 "%" -o "%:r.exe" && "%:r.exe"',
--         default = "make -k",
--       },
--
--       -- Tell the engine to parse macro expansions like '%' or '%:r' inside prompts
--       bang_expansion = true,
--
--       -- Force :Recompile to seamlessly trigger :Compile if history is completely empty
--       recompile_no_fail = true,
--
--       ask_about_save = true,
--       ask_to_interrupt = true,
--       auto_scroll = true,
--       focus_compilation_buffer = false,
--       buffer_name = "*compilation*",
--       baleia_setup = true,
--     }
-- end,
--
--   -- 2. Define Standardized Keymaps matching native Vim framework lazy boundaries
--   keys = {
--     { "<leader>cc", "<cmd>Compile<CR>", desc = "Compile Command", mode = "n" },
--     { "<leader>cR", "<cmd>Recompile<CR>", desc = "Recompile Last", mode = "n" },
--   },
-- }

return {
  "ej-shafran/compile-mode.nvim",
  version = "^5.0.0",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "m00qek/baleia.nvim", tag = "v1.3.0" },
  },
  config = function()
    -- =========================================================================
    -- LOCAL ENGINE (Resolves build.bat or falls back to single-file g++)
    -- =========================================================================
    local function get_local_build_command()
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir = (current_file ~= "") and vim.fs.dirname(current_file) or (vim.uv.cwd() or "")

      local expected_path = current_dir .. "/build.bat"
      expected_path = vim.fs.normalize(expected_path)

      if vim.uv.fs_stat(expected_path) then
        return expected_path
      else
        return 'g++ -std=c++20 "%" -o "%:r.exe" && "%:r.exe"'
      end
    end

-- =========================================================================
    -- LINE WRAP FOR COMPILATION BUFFER (Bulletproof Window Hook)
    -- =========================================================================
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*",
      callback = function()
        -- Only apply line-wrapping if this window is displaying the compilation buffer
        if vim.bo.filetype == "compile-mode" then
          vim.wo.wrap = true       -- Visual line wrapping
          vim.wo.linebreak = true  -- Do not snap mid-word/path boundaries
        end
      end,
    })

    -- =========================================================================
    -- PLUGIN CONFIGURATION REGISTER
    -- =========================================================================
    vim.g.compile_mode = {
      default_command = function()
        local ft = vim.bo.filetype

        if ft == "cpp" or ft == "c" then
          return get_local_build_command()
        elseif ft == "python" then
          return 'python "%"'
        else
          return "make -k"
        end
      end,

      bang_expansion = true,
      recompile_no_fail = true,
      ask_about_save = true,
      ask_to_interrupt = true,
      auto_scroll = true,
      focus_compilation_buffer = false,
      buffer_name = "*compilation*",
      baleia_setup = true,
    }
  end,

  -- =========================================================================
  -- STANDARDIZED KEYMAPS
  -- =========================================================================
  keys = {
    { "<leader>cR", "<cmd>Compile<CR>", desc = "Compile Command", mode = "n" },
    { "<leader>cc", "<cmd>Recompile<CR>", desc = "Recompile Last", mode = "n" },
  },
}
