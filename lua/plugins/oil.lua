return {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
        local config = require("oil")

        config.setup {
            default_file_explorer = false,
            keymaps = {
                ["<BS>"] = { "actions.parent", mode = "n" },
                ["<Esc>"] = { "actions.close", mode = "n" },
                ["."] = { "actions.toggle_hidden", mode = "n" },
            },
            float = {
                max_width = 90,
                max_height = 25,
            },
        }

        vim.keymap.set("n", "<C-b>", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })
    end,
}
