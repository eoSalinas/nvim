return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    init = function()
        -- Load fzf-lua on first vim.ui.select call; it replaces this on load
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...)
            require("lazy").load({ plugins = { "fzf-lua" } })
            return vim.ui.select(...)
        end
    end,
    opts = {
        winopts = {
            preview = {
                hidden = true,
            },
        },
        keymap = {
            builtin = {
                ["<C-t>"] = "toggle-preview",
            },
        },
    },
    config = function(_, opts)
        local fzf = require("fzf-lua")
        fzf.setup(opts)
        fzf.register_ui_select()
    end,
}
