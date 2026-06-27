return {
  "ej-shafran/compile-mode.nvim",
  version = "^5.0.0",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "m00qek/baleia.nvim", tag = "v1.3.0" },
  },
  config = function()
    -- Set configuration options on the global table expected by the plugin
    vim.g.compile_mode = {
      -- Define static templates per filetype; the plugin engine parses these
      default_command = {
        python = 'python "%"',
        cpp = 'g++ -std=c++20 "%" -o "%:r.exe" && "%:r.exe"',
        c = 'g++ -std=c++20 "%" -o "%:r.exe" && "%:r.exe"',
        default = "make -k",
      },

      -- Tell the engine to parse macro expansions like '%' or '%:r' inside prompts
      bang_expansion = true,

      -- Force :Recompile to seamlessly trigger :Compile if history is completely empty
      recompile_no_fail = true,

      ask_about_save = true,
      ask_to_interrupt = true,
      auto_scroll = true,
      focus_compilation_buffer = false,
      buffer_name = "*compilation*",
      baleia_setup = true,
    }

    -- Standardized Keymaps matching native Vim command execution boundaries
    -- <leader>cc will open the prompt pre-filled with the calculated filetype command
    vim.keymap.set("n", "<leader>cc", "<cmd>Compile<CR>", { desc = "Compile Command" })

    -- <leader>cO will re-execute the last run history sequence natively
    vim.keymap.set("n", "<leader>cR", "<cmd>Recompile<CR>", { desc = "Recompile Last" })

    -- Clean Which-key registration via its exposed API
    local wk = require("which-key")
    wk.add({
      { "<leader>c", group = "+compile" },
      { "<leader>cc", desc = "Compile Command" },
      { "<leader>cR", desc = "Recompile Last" },
    })
  end,
}
