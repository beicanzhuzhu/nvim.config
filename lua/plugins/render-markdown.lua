return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown', 'quarto' },
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    log_level = 'error',
    log_runtime = false,
    code = {
      enabled = true,
      render_modes = false,
      sign = true,
      style = 'full',
      position = 'left',
      language_pad = 0,
      language_name = true,
      disable_background = { 'diff' },
      width = 'full',
      left_margin = 0,
      left_pad = 0,
      right_pad = 0,
      min_width = 0,
      border = 'thin',
      above = '▄',
      below = '▀',
      highlight = 'RenderMarkdownCode',
      highlight_language = nil,
      inline_pad = 0,
      highlight_inline = 'RenderMarkdownCodeInline',
    },

  },
}
