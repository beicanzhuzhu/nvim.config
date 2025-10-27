return {
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {
            indent = {
                char = "│",
            },
            scope = {
                enabled = false,
            }
        },
    },
    {
        'echasnovski/mini.indentscope',
        event = "VeryLazy",
        version = false,
        opts = {
            symbol = "│",
        },
    },
}
