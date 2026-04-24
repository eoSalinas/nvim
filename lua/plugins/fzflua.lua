return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local config = require("fzf-lua")
        config.setup {
            winopts = {
                preview = {
                    hidden = true,
                }
            },
            keymap = {
                builtin = {
                    ["<C-t>"] = "toggle-preview",
                },
            },
        }

        vim.keymap.set("n", "<C-n>", function()
            require("fzf-lua").files()
        end, { desc = "Find Files in project directory" })

        vim.keymap.set("n", "<leader>ps", function()
            require("fzf-lua").live_grep()
        end, { desc = "Find by grepping in project directory" })

        vim.keymap.set("n", "<leader>fw", function()
            require("fzf-lua").grep_cword()
        end, { desc = "[F]ind current [W]ord" })

        vim.keymap.set("n", "<leader>fd", function()
            require("fzf-lua").diagnostics_document()
        end, { desc = "[F]ind [D]iagnostics" })

        vim.keymap.set("n", "<leader>fc", function()
            require("fzf-lua").files({
                cwd = vim.fn.stdpath("config"),
            })
        end, { desc = "Find in neovim configuration" })
    end,
}
