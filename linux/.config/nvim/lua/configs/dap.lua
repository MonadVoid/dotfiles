local dap = require "dap"

-- Wipe any auto-loaded ones from mason-nvim-dap or others
dap.configurations.cpp = {} -- clear defaults

-- Path to the codelldb adapter installed by Mason
local mason_path = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension"
local codelldb_path = mason_path .. "/adapter/codelldb"
local liblldb_path = mason_path .. "/lldb/lib/liblldb.so" -- or .dylib on macOS

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = codelldb_path,
    args = { "--port", "${port}" },
    detached = false,
  },
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dap.configurations.c = dap.configurations.cpp
