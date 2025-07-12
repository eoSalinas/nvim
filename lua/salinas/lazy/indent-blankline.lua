return {
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			local function get_ibl_config(state)
				return {
					enabled = state,
					indent = {
						char = "│",
						tab_char = "│",
					},
					scope = { show_start = false, show_end = false },
					exclude = {
						filetypes = {
							"help",
							"neo-tree",
							"lazy",
							"mason",
						},
					},
				}
			end

			require("ibl").setup(get_ibl_config(false))

			vim.keymap.set("n", "<leader>ti", function()
				local state = require("ibl.config").get_config(0).enabled
				require("ibl").setup(get_ibl_config(not state))
			end, {})
		end,
		main = "ibl",
	},
}
