return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = true,
            refresh = {
                statusline = 100,
                tabline = 100,
                winbar = 100,
            }
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff' },
            lualine_c = {
                "filename",
                {
                    "diagnostics",
                    symbols = {
                        error = " ",
                        warn = " ",
                        info = " ",
                        hint = " ",
                    },
                },
                { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            },
            lualine_x = { 'encoding', 'fileformat', 'progress' },
            lualine_y = { 'location' },
            lualine_z = {
                function()
                    return " " .. os.date("%R")
                end,
            }
        },
        -- extensions = { "neo-tree" }
    }
}
