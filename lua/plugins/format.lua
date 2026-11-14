return {
    {
        "stevearc/conform.nvim",
        dependencies = { "j-hui/fidget.nvim" },
        config = function()
            local conform = require("conform")

            vim.keymap.set("n", "<leader>tf", function()
                vim.g.disable_format_on_save = not vim.g.disable_format_on_save
                local state = vim.g.disable_format_on_save and "disabled" or "enabled"
                require("fidget").notify("Format on save " .. state, vim.log.levels.INFO)
            end, { desc = "Toggle format on save" })

            vim.keymap.set("n", "<leader>cf", function()
                conform.format({ lsp_format = "fallback" })
            end, { desc = "Format buffer" })

            -- Filetypes where LSP formatting is never used as fallback
            local no_lsp_format = { c = true, cpp = true }

            conform.setup({
                notify_on_error = false,
                format_on_save = function(bufnr)
                    if vim.g.disable_format_on_save then
                        return
                    end
                    return {
                        timeout_ms = 2500,
                        lsp_format = no_lsp_format[vim.bo[bufnr].filetype] and "never" or "fallback",
                    }
                end,
                formatters_by_ft = {
                    lua = { "stylua" },
                    javascript = { "oxfmt" },
                    javascriptreact = { "oxfmt" },
                    typescript = { "oxfmt" },
                    typescriptreact = { "oxfmt" },
                    json = { "oxfmt" },
                },
            })
        end,
    },
}
