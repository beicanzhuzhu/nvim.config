local py_interpreter_name = "python3"

if not vim.fn.has("unix") then
    py_interpreter_name = "python"
end

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
        py_exec = py_interpreter_name,
        cpp_c = "clang++",
        c_c = "clang",
    }
}
