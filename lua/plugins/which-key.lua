return {

  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
    { "<leader>r", "<cmd>Autorun<CR>",         desc = "Run your code" },
    { "<leader>e", "<cmd>Neotree toggle<CR>",  desc = "Explorer" },
    { "<leader>R", "<cmd>Autodap<CR>",         desc = "Dap your cpp code" },
  },

}
