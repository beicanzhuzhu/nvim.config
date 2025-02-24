return {
  'ShangYJQ/autorun.nvim',
  event = "VeryLazy",
  dependencies = {
    {
      'akinsho/toggleterm.nvim',
    },
  },
  opts = {
    py_exec = "python3",
    cpp_c = "clang++",
    c_c = "clang",
  }
}
