vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<A-s>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<A-e>", "<cmd>silent !tmux neww yazi<CR>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>v", ":vsplit<CR>")
vim.keymap.set("n", "<leader>h", ":split<CR>")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>")

vim.api.nvim_create_user_command("Update", function()
    vim.notify("Updating...")
    vim.fn.jobstart({ "git", "pull" }, {
        cwd = vim.fn.stdpath("config"),
        on_exit = function(_, code)
            if code ~= 0 then
                vim.notify("git pull failed", vim.log.levels.ERROR)
                return
            end
            vim.cmd("Lazy restore")
            vim.notify("Neovim updated, restart to apply changes.")
        end,
    })
end, { desc = "Pull config and restore plugins" })

vim.keymap.set("n", "<leader>o", function()
    local word = vim.fn.expand("<cWORD>")
    vim.fn.jobstart({ "xdg-open", word }, { detach = true })
end, { silent = true })

vim.keymap.set("n", "<leader>cp", function()
    local path = vim.fn.expand("%")
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path)
end, { desc = "Copy file path to clipboard" })
