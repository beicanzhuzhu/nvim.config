return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = {
                "c",
                "cpp",
                "lua",
                "python",
                "rust",
                "markdown_inline",
            },
            sync_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
