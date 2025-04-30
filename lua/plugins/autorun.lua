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
        py_exec = vim.g.py_exec,
        cpp_c = vim.g.cpp_c,
        c_c = vim.g.c_c,
    }
}
