vim.api.nvim_create_autocmd('VimEnter',
  {
    pattern = { '*' },
    command = 'Neotree toggle'
  })

vim.api.nvim_create_autocmd('VimEnter',
  {
    pattern = { '*' },
    command = 'wincmd p'
  })


vim.api.nvim_create_autocmd('InsertLeave',
  {
    pattern = { '*' },
    command = 'w'
  })
