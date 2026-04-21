return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
    },
    opts = {
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        sources = {
            "filesystem",
            "buffers",
            "git_status",
        },
        filesystem = {
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            filtered_items = {
                visible = true,
                show_hidden_count = true,
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_by_name = {
                    ".git",
                    ".DS_Store",
                },
            },
            use_libuv_file_watcher = true,
        },
        window = {
            width = 35,
            side = "left",
            mappings = {
                ["<space>"] = "none",
            },
        },
        default_component_configs = {
            indent = {
                with_expanders = true,
                expander_collapsed = "",
                expander_expanded = "",
            },
            git_status = {
                symbols = {
                    added = "+",
                    deleted = "-",
                    modified = "~",
                    renamed = ">>",
                    untracked = "?",
                    ignored = "I",
                    unstaged = "U",
                    staged = "S",
                    conflict = "!",
                },
            },
        },
    },
    config = function(_, opts)
        require("neo-tree").setup(opts)

        -- Remove visual distinction between neo-tree sidebar and editor
        vim.api.nvim_create_autocmd("User", {
            pattern = "NeoTreeBufferEnter",
            callback = function()
                local normal_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "bg#")
                vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = normal_bg ~= "" and normal_bg or nil })
                vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = normal_bg ~= "" and normal_bg or nil })
                vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { link = "VertSplit" })
                vim.api.nvim_set_hl(0, "NeoTreeVertSplit", { link = "VertSplit" })
            end,
        })
    end,
}
