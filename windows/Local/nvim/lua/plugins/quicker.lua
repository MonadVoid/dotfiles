return {
  "stevearc/quicker.nvim",
  ft = "qf",
  opts = {
    use_default_opts = true,

    context = {
      enabled = true, -- required for context feature
    },

    opts = { -- buffer-local settings
      number = true,
      relativenumber = false,
      wrap = false,
    },

    -- Runs once when quicker quickfix buffer is created
    on_qf = function(bufnr)
      -- === Custom <CR> mapping (opens in main window + closes quicker) ===
      vim.keymap.set("n", "<CR>", function()
        local qf_list = vim.fn.getqflist()
        local idx = vim.fn.line(".") - 1
        if idx < 0 or idx >= #qf_list then
          return
        end

        local entry = qf_list[idx + 1]
        if not entry or (not entry.bufnr and not entry.filename) then
          vim.cmd("execute 'normal! \\<CR>'")
          return
        end

        local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr or 0)

        -- Go to previous/main window
        vim.cmd("wincmd p")

        -- Close quicker window
        require("quicker").close()

        -- Open file safely
        vim.cmd("silent! edit " .. vim.fn.fnameescape(filename))

        -- Jump to correct line & column
        if entry.lnum and entry.lnum > 0 then
          vim.api.nvim_win_set_cursor(0, { entry.lnum, math.max(0, (entry.col or 1) - 1) })
        end

        vim.cmd("normal! zz")
      end, { buffer = bufnr, silent = true, desc = "Open in main window and close quicker" })

      -- === Manual Context Controls (no stutter on j/k) ===
      vim.keymap.set("n", ">", function()
        require("quicker").expand({ before = 5, after = 5, add_to_existing = true })
      end, { buffer = bufnr, desc = "Expand context (more lines)" })

      vim.keymap.set("n", "<", function()
        require("quicker").collapse()
      end, { buffer = bufnr, desc = "Collapse context" })

      -- Optional: toggle context on/off with a key (e.g. `c`)
      vim.keymap.set("n", "c", function()
        -- Simple toggle (you can improve this later if needed)
        require("quicker").collapse()
      end, { buffer = bufnr, desc = "Collapse all context" })
    end,
  },
}
