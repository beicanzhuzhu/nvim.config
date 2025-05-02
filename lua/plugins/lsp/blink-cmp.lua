return {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    version = '1.*',
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config

    opts = {
        keymap     = {
            preset = 'none',

            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<cr>'] = { 'accept', 'fallback' },

            ['C-Down'] = { 'scroll_documentation_down', 'fallback' },
            ['C-Up'] = { 'scroll_documentation_up', 'fallback' },

            ['<Tab>'] = { 'snippet_forward', 'fallback' },
            ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },

        },
        cmdline    = {
            keymap = {
                preset = 'none',
                ['<Tab>'] = {
                    function(cmp)
                        if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then return cmp.accept() end
                    end,
                    'show_and_insert',
                    'select_next',
                },
                ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },

                ['<C-n>'] = { 'select_and_accept' },
                ['<C-e>'] = { 'cancel' },
            }
        },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono'
        },
        completion = {
            list = { selection = { preselect = false, auto_insert = true } },
            menu = {
                border = 'single',
                draw = {
                    columns = {
                        { "label",     "label_description", gap = 1 },
                        { "kind_icon", "kind" }
                    }
                },
            },
            documentation = {
                window = { border = 'single', },
                auto_show = true,
                auto_show_delay_ms = 500,
            },
            ghost_text = { enabled = true },
        },
        signature  = { window = { border = 'single' } },
        sources    = {
            default = { 'lsp', 'path', 'snippets', 'buffer', 'markdown' },
            providers = {
                markdown = {
                    name = 'RenderMarkdown',
                    module = 'render-markdown.integ.blink',
                    fallbacks = { 'lsp' },
                },
            },
        },
        fuzzy      = { implementation = "prefer_rust" },
    },
    opts_extend = { "sources.default" }
}
