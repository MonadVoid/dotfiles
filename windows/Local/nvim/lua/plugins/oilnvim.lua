return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "-", "<CMD>Oil<CR>", desc = "Open Parent Directory (Oil)" },
    },
    opts = {
        view_options = {
            show_hidden = true,
        },
        sync_install = true,
        lazy = false
    },
    config = function(_, opts)
        require("oil").setup(opts)

        -- The Senior Way: Defensive, plural-aware, and safe
        vim.api.nvim_create_autocmd("User", {
            pattern = "OilActionsPost",
            callback = function(event)
                -- 1. Use vim.tbl_get for safe access (The Teej Way)
                local actions = vim.tbl_get(event, "data", "actions")
                if not actions then return end

                -- 2. Check if any of the actions performed was a 'save'
                -- Oil often bundles multiple actions into this list
                for _, action in ipairs(actions) do
                    if action.type == "save" or action.type == "create" then
                        local dir = require("oil").get_current_dir()
                        if dir then
                            vim.api.nvim_set_current_dir(dir)
                        end
                        -- Once we've synced the CD, we can stop looping
                        break
                    end
                end
            end,
        })
    end,
}
