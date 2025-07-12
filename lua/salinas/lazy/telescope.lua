return {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = function()
			require("telescope").setup({
				defaults = {
					sorting_strategy = "ascending",
					layout_config = { prompt_position = "top" },
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
					file_browser = {
						theme = "dropdown",
						previewer = false,
						layout_config = { height = 30 },
						hidden = true,
					},
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
			vim.keymap.set("n", "<C-p>", builtin.git_files, {})
			vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})

			vim.keymap.set("n", "<leader>pb", ":Telescope file_browser<CR>")
			vim.keymap.set("n", "<C-n>", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("file_browser")
			require("telescope").load_extension("fzf")
		end,
	},
}
