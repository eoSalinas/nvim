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
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "j-hui/fidget.nvim", opts = {} },

            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- registers its LSP capabilities via vim.lsp.config("*"),
            -- so it must load before servers are enabled
            "saghen/blink.cmp",
        },
        config = function()
            require("mason").setup({})

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    require("config.keymaps").lsp(event.buf, client)

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
        end,
    },
}
