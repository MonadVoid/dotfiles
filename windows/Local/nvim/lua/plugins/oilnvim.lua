return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Oil",
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open Parent Directory (Oil)" },
    },
    opts = {
      default_file_explorer = true,
      columns = { "icon" },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == "node_modules" or name == ".git" or name == "build"
        end,
      },
      constrain_to_file_system = true,
      experimental_watch_for_changes = true,
    },
    config = function(_, opts)
      local oil = require("oil")
      oil.setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        desc = "Synchronize window-local working directory after filesystem mutation",
        callback = function(event)
          local actions = vim.tbl_get(event, "data", "actions")
          if not actions then
            return
          end

          -- Check if any action requires a directory update
          local should_update = vim.iter(actions):any(function(a)
            return a.type == "save" or a.type == "create" or a.type == "delete"
          end)

          if not should_update then
            return
          end

          local current_dir = oil.get_current_dir()
          if not current_dir then
            return
          end

          -- Resolve project root or fallback to current directory
          local target_dir = current_dir
          local ok, lsp_util = pcall(require, "lspconfig.util")
          if ok then
            local root = lsp_util.root_pattern(".clangd", "build-all.bat", ".git")(current_dir)
            if root then
              target_dir = root
            end
          end

          -- Use pcall/protected execution for filesystem operations
          local success, _ = pcall(vim.cmd.lcd, target_dir)
          if not success then
            vim.notify("Oil: Failed to set local directory to " .. target_dir, vim.log.levels.WARN)
          end
        end,
      })
    end,
  },
}
