return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local config = require("nvim-treesitter")
            config.install({
                -- systems
                "lua",
                "c",
                "rust",
                -- vim
                "vim",
                "vimdoc",
                -- web
                "javascript",
                "jsx",
                "typescript",
                "tsx",
                "html",
                "css",
                -- data
                "json",
                "toml",
                "yaml",
                -- ops
                "bash",
                "dockerfile",
                "gitcommit",
            })

            vim.api.nvim_create_autocmd("FileType", {
                desc = "Start treesitter highlighting and indent",
                group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
                callback = function(args)
                    if pcall(vim.treesitter.start, args.buf) then
                        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            local config = require("treesitter-context")
            config.setup({
                max_lines = 1,
            })
        end,
    },
}
