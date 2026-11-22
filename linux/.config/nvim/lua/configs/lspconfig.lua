require("nvchad.configs.lspconfig").defaults()

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--clang-tidy",
    "--background-index",
    "--offset-encoding=utf-8", -- Required for some C++ projects
  },
  root_markers = { ".clangd", "compile_commands.json", ".git" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
})

-- Python LSP setup (Pyright)
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic", -- can be "off", "basic", or "strict"
      },
    },
  },
})

-- Assembly (asm-lsp)
vim.lsp.config("asm_lsp", {
  cmd = { "asm-lsp" },
  filetypes = { "asm", "s" }, -- adjust if your assembly files use a different extension
  root_markers = { ".git" },
})

local servers = { "html", "cssls", "clangd", "pyright", "asm_lsp" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
