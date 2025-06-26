return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>g", "<cmd>Telescope grep_string word_match=-w<cr>" },
		{ "<leader>ga", "<cmd>Telescope grep_string word_match=-w search_dirs=app<cr>" },
		{ "<leader>G", "<cmd>Telescope live_grep<cr>" },
	},
	opts = {
		defaults = {
			mappings = {
				i = {
					["<esc>"] = require("telescope.actions").close,
				},
				n = {
					["<esc>"] = require("telescope.actions").close,
				},
			},
		},
	},
}
