
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", "\"_d")

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

vim.keymap.set(
    "n",
    "<leader>ea",
    "oassert.NoError(err, \"\")<Esc>F\";a"
)

vim.keymap.set(
    "n",
    "<leader>ef",
    "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj"
)

vim.keymap.set(
    "n",
    "<leader>el",
    "oif err != nil {<CR>}<Esc>O.logger.Error(\"error\", \"error\", err)<Esc>F.;i"
)

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/assah/lazy_init.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- Java specific keymaps
vim.keymap.set("n", "<leader>js", function()
    -- Force start nvim-java
    require('java').setup()
    print("nvim-java setup initiated...")
end, { desc = 'Java: Force Start' })

vim.keymap.set("n", "<leader>jl", function()
    -- Check LSP status
    local clients = vim.lsp.get_active_clients()
    print("Active LSP clients: " .. #clients)
    for i, client in ipairs(clients) do
        print("  " .. i .. ". " .. client.name)
    end
end, { desc = 'Java: List LSP Clients' })

vim.keymap.set("n", "<leader>jv", function()
    local clients = vim.lsp.get_active_clients({ name = 'jdtls' })
    if #clients == 0 then
        print("No JDTLS client found. Try <leader>js first, then open a Java file.")
        return
    end
    require('java').settings.change_runtime()
end, { desc = 'Java: Change Version' })

vim.keymap.set("n", "<leader>jr", function()
    require('java').runner.built_in.run_app()
end, { desc = 'Java: Run Application' })

vim.keymap.set("n", "<leader>jt", function()
    require('java').test.run_current_class()
end, { desc = 'Java: Test Current Class' })

vim.keymap.set("n", "<leader>jm", function()
    require('java').test.run_current_method()
end, { desc = 'Java: Test Current Method' })

vim.keymap.set("n", "<leader>jd", function()
    require('java').test.debug_current_method()
end, { desc = 'Java: Debug Current Method' })

vim.keymap.set("n", "<leader>jp", function()
    require('java').profile.ui()
end, { desc = 'Java: Profiles UI' })


-- [[
-- vim.keymap.set("n", "<leader>r", ":set norelativenumber!<CR>", { noremap = true, silent = true })
-- ]]
