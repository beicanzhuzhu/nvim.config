return {

    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        modes = {
            char = { enabled = false }
        }
    },
    keys = {
        { "'",     mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
        { "<a-'>", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    }

}
