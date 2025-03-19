vim.opt.termguicolors = true

return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
        highlights = {
            fill = { bg = "#1a1b26" }, -- 背景颜色
            background = { fg = "#545c7e", bg = "#1a1b26" },
            buffer_selected = { fg = "#c0caf5", bg = "#32344a", bold = false },
            buffer_visible = { fg = "#a9b1d6", bg = "#1a1b26" },
            separator = { fg = "#3b4261", bg = "#1a1b26" },
            separator_selected = { fg = "#7aa2f7", bg = "#32344a" },
            modified = { fg = "#e0af68", bg = "#1a1b26" },
            modified_selected = { fg = "#e0af68", bg = "#32344a" },
        },
        options = {
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "Explorer",
                    text_align = "center",
                    separator = false,
                    highlight = "PanelHeading",
                    padding = 1,
                },
                {
                    filetype = "lazy",
                    text = "Lazy",
                    highlight = "PanelHeading",
                    padding = 1,
                },
            },
        },
    },
}
