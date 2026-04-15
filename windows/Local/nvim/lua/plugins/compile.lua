-- return {
--   "ej-shafran/compile-mode.nvim",
--   version = "^5.0.0",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     { "m00qek/baleia.nvim", tag = "v1.3.0" },
--   },
--   config = function()
--     vim.g.compile_mode = {
--       default_command = "g++ -std=c++20 ",
--       ask_about_save = true,
--       ask_to_interrupt = true,
--       auto_scroll = true,
--       focus_compilation_buffer = false,
--       buffer_name = "*compilation*",
--       baleia_setup = true,
--     }
--
--     -- Register which-key group
--     local wk = require("which-key")
--     wk.add({
--       { "<leader>c", group = "+compile" },
--       { "<leader>co", "<cmd>Compile<CR>", desc = "Compile (M-x compile)" },
--       { "<leader>cO", "<cmd>Recompile<CR>", desc = "Recompile last" },
--       { "<leader>cn", "<cmd>NextError<CR>", desc = "Next error" },
--       { "<leader>cp", "<cmd>PrevError<CR>", desc = "Previous error" },
--     })
--
--     -- Make 'q' close the compilation buffer when you're inside it (Emacs/LazyVim style)
--     vim.api.nvim_create_autocmd("FileType", {
--       pattern = "compile-mode",
--       callback = function()
--         vim.keymap.set("n", "q", function()
--           vim.cmd("bdelete!")
--         end, { buffer = true, silent = true, desc = "Close compilation buffer" })
--       end,
--     })
--   end,
-- }

return {
  "ej-shafran/compile-mode.nvim",
  version = "^5.0.0",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "m00qek/baleia.nvim", tag = "v1.3.0" },
  },
  config = function()
    local compile = require("compile-mode")

    vim.g.compile_mode = {
      default_command = "make -k ",
      ask_about_save = true,
      ask_to_interrupt = true,
      auto_scroll = true,
      focus_compilation_buffer = false,
      buffer_name = "*compilation*",
      baleia_setup = true,
    }

    -- Smart default command
    local function get_smart_command()
      local filetype = vim.bo.filetype
      local cwd = vim.fn.getcwd()

      if vim.fn.filereadable(cwd .. "/Makefile") == 1 or vim.fn.filereadable(cwd .. "/makefile") == 1 then
        return "make -k"
      end

      if filetype == "python" then
        return "python " .. vim.fn.expand("%:p")
      elseif filetype == "cpp" or filetype == "c" then
        local file = vim.fn.expand("%:p")
        local outfile = vim.fn.expand("%:p:r") .. ".exe"
        return string.format('g++ -std=c++20 "%s" -o "%s" && "%s"', file, outfile, outfile)
      end

      return "make -k"
    end

    -- 1. Smart Compile (auto-detect)
    vim.keymap.set("n", "<leader>co", function()
      local cmd = get_smart_command()
      vim.cmd("Compile! " .. cmd)
    end, { desc = "Compile (Smart)" })

    -- 2. Custom Compile (like real M-x compile)
    vim.keymap.set("n", "<leader>cc", function()
      local default_cmd = get_smart_command()
      vim.ui.input({
        prompt = "Compile command: ",
        default = default_cmd,
      }, function(input)
        if input and input ~= "" then
          vim.cmd("Compile! " .. input)
        end
      end)
    end, { desc = "Compile (Custom Command)" })

    -- 3. Recompile last
    vim.keymap.set("n", "<leader>cO", "<cmd>Recompile<CR>", { desc = "Recompile Last" })

    -- Navigation
    vim.keymap.set("n", "<leader>cn", "<cmd>NextError<CR>", { desc = "Next Error" })
    vim.keymap.set("n", "<leader>cp", "<cmd>PrevError<CR>", { desc = "Previous Error" })

    -- Which-key registration
    local wk = require("which-key")
    wk.add({
      { "<leader>c", group = "+compile" },
      { "<leader>co", desc = "Compile (Smart)" },
      { "<leader>cc", desc = "Compile (Custom)" },
      { "<leader>cO", desc = "Recompile Last" },
    })
  end,
}
