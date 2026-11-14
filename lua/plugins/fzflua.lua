return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
        -- stylua: ignore start
        { "<C-n>", function() require("fzf-lua").files() end, desc = "Find Files in project directory" },
        { "<leader>ps", function() require("fzf-lua").live_grep() end, desc = "Find by grepping in project directory" },
        { "<leader>fw", function() require("fzf-lua").grep_cword() end, desc = "[F]ind current [W]ord" },
        { "<C-f>", function() require("fzf-lua").grep_visual() end, mode = "v", desc = "Grep selected text in project" },
        { "<leader>fd", function() require("fzf-lua").diagnostics_document() end, desc = "[F]ind [D]iagnostics" },
        { "<leader>gb", function() require("fzf-lua").git_branches() end, desc = "Git branches" },
        { "<leader>gc", function() require("fzf-lua").git_commits() end, desc = "Git commits" },
        { "<leader>fc", function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find in neovim configuration" },
        -- stylua: ignore end
    },
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
