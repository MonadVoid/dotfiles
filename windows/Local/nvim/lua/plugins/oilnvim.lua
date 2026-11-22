-- return {
--   {
--     "stevearc/oil.nvim",
--     dependencies = { "nvim-tree/nvim-web-devicons" },
--     cmd = "Oil",
--     keys = {
--       { "-", "<CMD>Oil<CR>", desc = "Open Parent Directory (Oil)" },
--     },
--     opts = {
--       default_file_explorer = true,
--       columns = { "icon" },
--       view_options = {
--         show_hidden = true,
--         is_always_hidden = function(name, _)
--           return name == "node_modules" or name == ".git" 
--         end,
--       },
--       constrain_to_file_system = true,
--       experimental_watch_for_changes = true,
--     },
--     config = function(_, opts)
--       local oil = require("oil")
--       oil.setup(opts)
--
--       vim.api.nvim_create_autocmd("User", {
--         pattern = "OilActionsPost",
--         desc = "Synchronize window-local working directory after filesystem mutation",
--         callback = function(event)
--           local actions = vim.tbl_get(event, "data", "actions")
--           if not actions then
--             return
--           end
--
--           -- Check if any action requires a directory update
--           local should_update = vim.iter(actions):any(function(a)
--             return a.type == "save" or a.type == "create" or a.type == "delete"
--           end)
--
--           if not should_update then
--             return
--           end
--
--           local current_dir = oil.get_current_dir()
--           if not current_dir then
--             return
--           end
--
--           -- Resolve project root or fallback to current directory
--           local target_dir = current_dir
--           local ok, lsp_util = pcall(require, "lspconfig.util")
--           if ok then
--             local root = lsp_util.root_pattern(".clangd", "build-all.bat", ".git")(current_dir)
--             if root then
--               target_dir = root
--             end
--           end
--
--           -- Use pcall/protected execution for filesystem operations
--           local success, _ = pcall(vim.cmd.lcd, target_dir)
--           if not success then
--             vim.notify("Oil: Failed to set local directory to " .. target_dir, vim.log.levels.WARN)
--           end
--         end,
--       })
--     end,
--   },
-- }

-- Senior/Professional practice: Declare immutable constant lookup tables in the file scope.
-- This guarantees exactly ONE memory allocation, maximizing speed during massive directory listings.
local FILE_BLACKLIST = {
  ["node_modules"] = true,
  [".git"] = true,
}

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
          return FILE_BLACKLIST[name] or false
        end,
      },
      constrain_to_file_system = true,
      experimental_watch_for_changes = true,

      keymaps = {
        ["!"] = {
          desc = "Dired-style: Asynchronously execute shell command on current item",
          callback = function()
            local oil = require("oil")
            local entry = oil.get_cursor_entry()
            local dir = oil.get_current_dir()
            if not entry or not dir then return end

            -- Standardize system paths natively across Windows/Unix platforms
            local full_path = vim.fs.normalize(dir .. entry.name)

            vim.ui.input({
              prompt = string.format("Shell command on %s: ", entry.name),
              completion = "shellcmd",
            }, function(input)
              if not input or input:match("^%s*$") then return end

              -- SECURITY MATRIX: Strict tokenized parameter vector array allocation
              local cmd_args = {}
              for token in input:gmatch("%S+") do
                table.insert(cmd_args, token)
              end
              table.insert(cmd_args, full_path)

              -- Non-blocking native C libuv event loop handler system
              vim.system(cmd_args, { text = true }, function(obj)
                vim.schedule(function()
                  if obj.code ~= 0 then
                    local err = (obj.stderr and obj.stderr ~= "") and obj.stderr or ("Process exited with code " .. obj.code)
                    vim.notify("Command failed:\n" .. err, vim.log.levels.ERROR)
                    return
                  end

                  local output = vim.split(obj.stdout or "", "\n", { trimempty = true })
                  if #output == 0 then
                    vim.notify("Command completed with no output.", vim.log.levels.INFO)
                    return
                  end

                  -- Professional Ephemeral Scratch Buffer Engineering
                  local buf = vim.api.nvim_create_buf(false, true)
                  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
                  
                  -- Modern Attribute Configurations
                  vim.bo[buf].filetype = "sh"
                  vim.bo[buf].bufhidden = "wipe"  -- Automatic resource collection on viewport closure
                  vim.bo[buf].modifiable = false -- Immutability pattern protection

                  -- Ergonomic workflow: close the output split instantly with 'q'
                  vim.keymap.set("n", "q", "<CMD>close<CR>", { buffer = buf, silent = true, desc = "Close output split" })

                  -- Open viewport split explicitly and assign the buffer reference safely
                  vim.cmd("vsplit")
                  vim.api.nvim_win_set_buf(0, buf)
                end)
              end)
            end)
          end,
        },
      },
    },
    config = function(_, opts)
      local oil = require("oil")
      oil.setup(opts)

      -- System Guard Namespace: Clear and capture hooks cleanly to handle runtime hot-reloads
      local oil_sync_group = vim.api.nvim_create_augroup("OilDirectorySync", { clear = true })

      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        group = oil_sync_group,
        desc = "Synchronize window-local working directory natively after filesystem mutation",
        callback = function(event)
          local actions = vim.tbl_get(event, "data", "actions")
          if not actions then return end

          -- High-performance functional verification matching via functional iteration
          local should_update = vim.iter(actions):any(function(a)
            return a.type == "save" or a.type == "create" or a.type == "delete"
          end)

          if not should_update then return end

          local current_dir = oil.get_current_dir()
          if not current_dir then return end

          -- NEOVIM 0.12 MATCHING: Lightning fast C-layer structural project root resolution
          local target_dir = vim.fs.root(current_dir, { ".clangd", "build-all.bat", ".git" }) or current_dir

          -- Schedule path synchronization to execute safely outside internal event processing threads
          vim.schedule(function()
            local success, _ = pcall(vim.cmd.lcd, target_dir)
            if not success then
              vim.notify("Oil: Failed to set local directory to " .. target_dir, vim.log.levels.WARN)
            end
          end)
        end,
      })
    end,
  },
}
