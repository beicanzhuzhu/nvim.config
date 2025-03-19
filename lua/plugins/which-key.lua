return {

    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- Delay before showing the popup. Can be a number or a function that returns a number.
        ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
        delay = function(ctx)
            return ctx.plugin and 0 or 800
        end,
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },

}
