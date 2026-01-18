local lsp_server = {
    lua_ls = {},
    clangd = {
        cmd = {
            "clangd",
            "--query-driver=**",
            "--header-insertion=never",
            "--clang-tidy",
            "--background-index",
            "--completion-style=detailed"
        }
    },
    html = {},
    basedpyright = {},
    cmake = {},
}

return {
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'saghen/blink.cmp' },
        opts = { servers = lsp_server },
        config = function(_, opts)
            for server, config in pairs(opts.servers) do
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                vim.lsp.config[server] = config
                vim.lsp.enable(server)
            end
        end
    }
}
