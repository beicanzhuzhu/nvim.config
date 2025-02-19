return {
  'ShangYJQ/autorun.nvim',
  dependencies = {
    {
      'akinsho/toggleterm.nvim',
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
  },
  opts = {
    py_exec = "python3",
    cpp_c = "clang++",
    c_c = "clang",
  }
}
