return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ":TSUpdate",
        config = function ()
            local config = require("nvim-treesitter")
            config.install {
                "lua",
                "c",
                "rust",
                "vim",
                "vimdoc",
                "javascript",
                "typescript",
                "html", 
                "css",
                "json",
                "toml",
                "yaml",
                "bash",
                "dockerfile"
            }

            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end
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
