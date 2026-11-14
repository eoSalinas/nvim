return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            -- stylua: ignore start
            { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
            { "<C-e>", function() local h = require("harpoon") h.ui:toggle_quick_menu(h:list()) end, desc = "Harpoon menu" },
            { "<A-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
            { "<A-j>", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
            { "<A-k>", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
            { "<A-l>", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
            -- stylua: ignore end
        },
        opts = {
            settings = {
                save_on_toggle = true,
            },
        },
    },
}
