return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c",
                "cpp",
                "lua",
                "python",
                "rust",
                "markdown_inline",
            },
            compilers = { "clang" },
            highlight = { enable = true },
            indent = { enable = true },
        })
        require("nvim-treesitter.install").compilers = {"clang"}
    end
}
