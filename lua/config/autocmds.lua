local autosavefiletype = {
  "*.cpp",
  "*.c",
  "*.py",
}

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
    pattern = autosavefiletype,
    command = 'w'
  })

vim.api.nvim_create_autocmd("CmdlineEnter", {
  once = true,
  callback = function()
    local shada = vim.fn.stdpath("state") .. "/shada/main.shada"
    vim.o.shadafile = shada
    vim.api.nvim_command("rshada! " .. shada)
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    -- group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable()
        end
        -- whatever other lsp config you want
    end
})
