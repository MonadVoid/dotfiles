return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cpp = { "clang-format" },
        c = { "clang-format" },
      },
    },
    init = function()
      local function format_now()
        vim.schedule(function()
          require("lazyvim.util").format.format({ force = true })
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "cpp", "c" },
        callback = function()
          local opts = { buffer = true, silent = true, expr = true }

          -- 1. Semicolon: Format statement immediately
          vim.keymap.set("i", ";", function()
            format_now()
            return ";"
          end, opts)

          -- 2. Smart Closing Brace: Overtype + Format
          -- Fixed: Uses a direct cursor move instead of <Right> to avoid €kr symbols
          vim.keymap.set("i", "}", function()
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local char_after = line:sub(col + 1, col + 1)

            if char_after == "}" then
              -- Move cursor 1 space to the right manually
              vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col + 1 })
              format_now()
              return "" -- Return nothing because we already moved past the brace
            end

            format_now()
            return "}"
          end, opts)
        end,
      })
    end,
  },
}
