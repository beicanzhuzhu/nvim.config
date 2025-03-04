return {

  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  opts = {
    indent = { indent_size = 1 },
    window = {
      position = "left",
      width = 20,
      mappings = {
        ["l"] = "open",
        ["h"] = "navigate_up",
        ["."] = "toggle_hidden",
        ["H"] = "set_root";
      }
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      }
    },
  }
}
