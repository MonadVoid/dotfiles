local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    cpp = { "clang_format" },
    c = { "clang_format" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  formatters = {
    clang_format = {
      args = { "--style=file" },
    },
  },

  -- formatters = {
  --   clang_format = {
  --     -- No need to override command since Mason version is fine
  --     args = {
  --       "--style={BasedOnStyle: LLVM, BreakBeforeBraces: Allman, IndentWidth: 2, NamespaceIndentation: All, IndentPPDirectives: AfterHash}",
  --     },
  --   },
  -- },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 10000,
    async = false,
    lsp_fallback = false,
  },
}

return options
