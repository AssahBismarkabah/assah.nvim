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

        -- Mason (tool installer)
        require("mason").setup()
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

        -- Global LSP defaults for all servers
        vim.lsp.config('*', {
            capabilities = capabilities,
            root_markers = { '.git' },
        })

        -- Lua language server
        vim.lsp.config('lua_ls', {
            root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
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

        -- Zig language server
        vim.lsp.config('zls', {
            root_markers = { '.git', 'build.zig', 'zls.json' },
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

        -- Rust
        vim.lsp.config('rust_analyzer', {
            root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
        })

        -- Go
        vim.lsp.config('gopls', {
            root_markers = { 'go.work', 'go.mod', '.git' },
        })

        -- Python
        vim.lsp.config('pyright', {
            root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
        })

        -- TypeScript/JavaScript
        vim.lsp.config('ts_ls', {
            root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
        })

        -- Enable all LSP servers (auto-attaches based on filetype)
        vim.lsp.enable({
            'lua_ls',
            'rust_analyzer',
            'gopls',
            'pyright',
            'ts_ls',
            'zls',
        })

        -- LspAttach autocmd for buffer-local settings
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('my_lsp_attach', {}),
            callback = function(ev)
                local bufnr = ev.buf
                local client = vim.lsp.get_client_by_id(ev.data.client_id)

                -- Enable completion (Neovim 0.12+ native API)
                if client and client:supports_method('textDocument/completion') then
                    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
                end

                -- Auto-format on save
                if client and client:supports_method('textDocument/formatting') then
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
                        end,
                    })
                end

                -- Buffer-local keymaps
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

        -- cmp setup (still works alongside vim.lsp.completion.enable)
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

        -- Diagnostics config
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
            update_in_insert = false,
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
