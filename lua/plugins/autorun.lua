return {
    'ShangYJQ/autorun.nvim',
    enabled = true,
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
