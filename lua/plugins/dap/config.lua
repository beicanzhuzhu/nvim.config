local dap = require("dap")

dap.set_log_level("ERROR")

dap.adapters.lldb = {
  type = 'executable',
  command = "/usr/bin/lldb-dap-18",
  name = 'lldb',
}

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  name = "gdb",
}

dap.configurations.cpp = {
  -- {
  --   name = "Launch with gdb",
  --   type = "gdb",
  --   request = "launch",
  --   program = function()
  --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
  --   end,
  --   cwd = "${workspaceFolder}",
  --   stopAtBeginningOfMainSubprogram = false,
  -- },
  {
    name = 'Launch with lldb',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}
