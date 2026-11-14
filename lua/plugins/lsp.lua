return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "j-hui/fidget.nvim",

            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            { "saghen/blink.cmp", version = "*", dependencies = { "rafamadriz/friendly-snippets" } },
            "stevearc/conform.nvim",
        },
        config = function()
            require("mason").setup({})
            local fidget = require("fidget")
            fidget.setup({})

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
                    end

                    map("gd", function()
                        require("fzf-lua").lsp_definitions()
                    end)
                    map("gr", function()
                        require("fzf-lua").lsp_references()
                    end)
                    map("gI", function()
                        require("fzf-lua").lsp_implementations()
                    end)

                    map("<C-k>", vim.lsp.buf.hover)
                    map("gD", vim.lsp.buf.declaration)
                    map("<leader>rn", vim.lsp.buf.rename)
                    map("<leader>ca", require("fzf-lua").lsp_code_actions)

                    map("<leader>D", function()
                        require("fzf-lua").lsp_typedefs()
                    end)

                    map("<leader>ds", function()
                        require("fzf-lua").lsp_document_symbols()
                    end)

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "Toggle inlay hints")
                    end
                end,
            })

            local diagnostic_signs = {}
            if vim.g.have_nerd_font then
                local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
                for type, icon in pairs(signs) do
                    diagnostic_signs[vim.diagnostic.severity[type]] = icon
                end
            end
            vim.diagnostic.config({
                signs = { text = diagnostic_signs },
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "",
                },
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
            })

            -- Per-server overrides. Capabilities from blink.cmp are injected
            -- globally by the plugin itself (vim.lsp.config("*")).
            local servers = {
                -- systems
                lua_ls = {},
                bashls = {},
                clangd = {},
                rust_analyzer = {},
                -- web
                ts_ls = {},
                html = {},
                cssls = {},
                tailwindcss = {},
                emmet_language_server = {},
                -- data
                jsonls = {},
                yamlls = {},
                -- tools
                oxfmt = {},
                oxlint = {},
            }

            for name, config in pairs(servers) do
                if next(config) ~= nil then
                    vim.lsp.config(name, config)
                end
            end

            local ensure_installed = vim.tbl_keys(servers)
            vim.list_extend(ensure_installed, {
                "stylua",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            -- mason-lspconfig v2: installed servers are enabled via vim.lsp.enable()
            require("mason-lspconfig").setup({})

            require("blink.cmp").setup({
                keymap = {
                    preset = "default",
                    ["<C-k>"] = {
                        function(cmp)
                            if cmp.is_documentation_visible() then
                                return cmp.hide_documentation()
                            else
                                return cmp.show_documentation()
                            end
                        end,
                        "fallback",
                    },
                },
                appearance = {
                    use_nvim_cmp_as_default = true,
                    nerd_font_variant = "mono",
                },
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                },
                completion = {
                    documentation = {
                        auto_show = false,
                    },
                },
            })

            local conform = require("conform")

            vim.keymap.set("n", "<leader>tf", function()
                if vim.g.disable_format_on_save then
                    vim.g.disable_format_on_save = false
                    fidget.notify("Format on save enabled", vim.log.levels.INFO)
                else
                    vim.g.disable_format_on_save = true
                    fidget.notify("Format on save disabled", vim.log.levels.INFO)
                end
            end, {})

            vim.keymap.set("n", "<leader>f", function()
                conform.format()
            end, {})

            conform.setup({
                notify_on_error = false,
                format_on_save = function(bufnr)
                    if vim.g.disable_format_on_save then
                        return
                    else
                        local disable_filetypes = { c = true, cpp = true }
                        local lsp_format_opt
                        if disable_filetypes[vim.bo[bufnr].filetype] then
                            lsp_format_opt = "never"
                        else
                            lsp_format_opt = "fallback"
                        end

                        return {
                            timeout_ms = 2500,
                            lsp_format = lsp_format_opt,
                        }
                    end
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
