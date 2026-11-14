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
                    local map = function(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
                    end

                    map("gd", function()
                        require("fzf-lua").lsp_definitions()
                    end)
                    -- Override nvim's default grr/gri with fzf-lua pickers
                    map("grr", function()
                        require("fzf-lua").lsp_references()
                    end)
                    map("gri", function()
                        require("fzf-lua").lsp_implementations()
                    end)

                    map("<C-k>", vim.lsp.buf.hover)
                    map("gD", vim.lsp.buf.declaration)
                    map("<leader>rn", vim.lsp.buf.rename)
                    map("<leader>ca", require("fzf-lua").lsp_code_actions)

                    map("<leader>D", function()
                        require("fzf-lua").lsp_typedefs()
                    end)

                    map("<leader>fs", function()
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
        end,
    },
}
