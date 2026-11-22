return {
  -- Disable flash.nvim completely
  { "folke/flash.nvim", enabled = false },

  -- Disable database plugins completely
  { "kristijanhusak/vim-dadbod-ui", enabled = false },
  { "tpope/vim-dadbod", enabled = false },
  { "kristijanhusak/vim-dadbod-completion", enabled = false },

  -- Clean blink.cmp patch (No typos this time!)
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}

      -- Remove dadbod from the active execution list
      if opts.sources.default then
        opts.sources.default = vim.tbl_filter(function(source)
          return source ~= "dadbod"
        end, opts.sources.default)
      end

      -- Unregister the provider definition entirely
      if opts.sources.providers then
        opts.sources.providers.dadbod = nil
      end

      return opts
    end,
  },
}
