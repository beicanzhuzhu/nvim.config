return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      offsets = {
        {
          filetype = "neo-tree",
          text = "Explorer",
          text_align = "center",
          separator = true,
          highlight = "PanelHeading",
          padding = 1,
        },
        {
          filetype = "lazy",
          text = "Lazy",
          highlight = "PanelHeading",
          padding = 1,
        },
      }
    },
  }
}
