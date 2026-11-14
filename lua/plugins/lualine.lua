return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            options = {
                theme = "rose-pine",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "encoding", "progress" },
                lualine_y = { { "branch", icon = "" } },
                lualine_z = {},
            },
            inactive_sections = {
                lualine_c = { { "filename", path = 1 } },
                lualine_x = {},
            },
        },
    },
}
