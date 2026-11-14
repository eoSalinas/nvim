return {
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TodoFzfLua", "TodoLocList" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
}
