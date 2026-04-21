return {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup({
            signs = {
                add          = { text = "┃" },
                change       = { text = "┃" },
                delete       = { text = "_" },
                topdelete    = { text = "‾" },
                changedelete = { text = "~" },
                untracked    = { text = "┆" },
            },
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 1000,
                virt_text_priority = 100,
                use_focus = true,
            },
            on_attach = function(bufnr)
                gitsigns.attach(bufnr)

                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]h", function()
                    if vim.wo.diff then return vim.cmd.normal({ "]c", bang = true }) end
                    gs.nav_hunk("next")
                end)
                map("n", "[h", function()
                    if vim.wo.diff then return vim.cmd.normal({ "[c", bang = true }) end
                    gs.nav_hunk("prev")
                end)

                -- Actions
                map("n", "<leader>hs", gs.stage_hunk)
                map("n", "<leader>hr", gs.reset_hunk)
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                map("n", "<leader>hS", gs.stage_buffer)
                map("n", "<leader>hR", gs.reset_buffer)
                map("n", "<leader>hp", gs.preview_hunk)
                map("n", "<leader>hi", gs.preview_hunk_inline)
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                end)
                map("n", "<leader>hd", gs.diffthis)
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end)

                -- Quickfix
                map("n", "<leader>hQ", function() gs.setqflist("all") end)
                map("n", "<leader>hq", function() gs.setqflist() end)

                -- Toggles
                map("n", "<leader>tb", gs.toggle_current_line_blame)
                map("n", "<leader>td", gs.toggle_deleted)
                map("n", "<leader>tw", gs.toggle_word_diff)

                -- Text object
                map({ "o", "x" }, "ih", gs.select_hunk)
            end,
        })
    end,
}
