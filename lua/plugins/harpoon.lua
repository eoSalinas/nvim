return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        lazy = true, -- loaded on require() from config/keymaps.lua
        opts = {
            settings = {
                save_on_toggle = true,
            },
        },
    },
}
