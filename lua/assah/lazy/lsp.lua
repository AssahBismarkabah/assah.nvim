return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        -- Conform (formatter)
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
            }
        })

        -- Fidget (LSP progress indicator)
        require("fidget").setup({})

        -- Mason: install all tool binaries
        require("mason").setup()

        -- Mason-lspconfig: wire Mason binaries to LSP server configs
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "pyright",
                "ts_ls",
                "zls",
            },
        })

        -- Global LSP defaults
        vim.lsp.config('*', {
            capabilities = capabilities,
        })

        -- Per-server settings only (no root_markers/filetype overrides — use server defaults)
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    workspace = {
                        checkThirdParty = false,
                        library = vim.api.nvim_get_runtime_file('', true),
                    },
                    diagnostics = {
                        globals = { 'vim', 'bit', 'it', 'describe', 'before_each', 'after_each' },
                    },
                },
            },
        })

        vim.lsp.config('zls', {
            settings = {
                zls = {
                    enable_inlay_hints = true,
                    enable_snippets = true,
                    warn_style = true,
                },
            },
        })
        vim.g.zig_fmt_parse_errors = 0
        vim.g.zig_fmt_autosave = 0

        -- Enable all servers
        vim.lsp.enable({
            'lua_ls',
            'rust_analyzer',
            'gopls',
            'pyright',
            'ts_ls',
            'zls',
        })

        -- LspAttach: completion, auto-format, keymaps
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('my_lsp_attach', {}),
            callback = function(ev)
                local bufnr = ev.buf
                local client = vim.lsp.get_client_by_id(ev.data.client_id)

                if client and client:supports_method('textDocument/completion') then
                    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
                end

                if client and client:supports_method('textDocument/formatting') then
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
                        end,
                    })
                end

                local opts = { buffer = bufnr }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            end,
        })

        -- cmp setup
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

        -- Diagnostics
        vim.diagnostic.config({
            virtual_text = {
                prefix = '●',
                source = 'if_many',
                spacing = 4,
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '■',
                    [vim.diagnostic.severity.WARN] = '!',
                    [vim.diagnostic.severity.INFO] = '•',
                    [vim.diagnostic.severity.HINT] = 'i',
                },
            },
            underline = true,
            update_in_insert = true,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
