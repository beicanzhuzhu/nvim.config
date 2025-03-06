local autosavefiletype = {
  "*.cpp",
  "*.c",
  "*.py",
  "*.h",
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
    callback = function()
      vim.fn.execute("silent! write")
      vim.notify("Auto save the file.", vim.log.levels.INFO, {})
    end
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

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
