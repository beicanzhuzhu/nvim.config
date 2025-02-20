local dap, dapui = require("dap"), require("dapui")

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

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
