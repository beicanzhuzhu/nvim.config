return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = {
                "c",
                "cpp",
                "lua",
                "python",
                "rust",
                "markdown_inline",
            },
            compilers = { "clang" },
            sync_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            auto_install = true,
            ignore_install = { "javascript" },
        })
        require("nvim-treesitter.install").compilers = { vim.g.c_c }
    end
}
