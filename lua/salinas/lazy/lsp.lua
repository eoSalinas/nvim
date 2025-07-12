return {
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
					vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, {})
					vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, {})
					vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations, {})
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

					vim.keymap.set("n", "<leader>D", require("telescope.builtin").lsp_type_definitions, {})

					vim.keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, {})

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						vim.keymap.set("n", "<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, {})
					end
				end,
			})

			if vim.g.have_nerd_font then
				local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
				local diagnostic_signs = {}
				for type, icon in pairs(signs) do
					diagnostic_signs[vim.diagnostic.severity[type]] = icon
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
						source = "always",
						header = "",
						prefix = "",
					},
				})
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
							},
						},
					},
				},
				bashls = {},
				clangd = {},
				rust_analyzer = {},
				jsonls = {},
				yamlls = {},
				cssls = {},
				html = {},
				tailwindcss = {},
				emmet_language_server = {},
				ts_ls = {},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			require("blink.cmp").setup({
				keymap = { preset = "default" },
				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
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
				},
			})
		end,
	},
}
