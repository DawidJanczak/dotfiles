return {
	-- LSP
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },

	-- Formatting
	{ "stevearc/conform.nvim" },
	{ "windwp/nvim-autopairs" },
	{ "machakann/vim-swap" },

	-- Misc
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup()
		end,
	},

	-- Catppuccin
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},

	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
				check_syntax_error = false, -- Postgres SQL will fail
			})

			vim.keymap.set("n", "<leader>j", require("treesj").toggle, { desc = "Toggle split/join" })
		end,
	},
	{
		"RRethy/nvim-treesitter-endwise",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "InsertEnter",
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"tpope/vim-sleuth",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"tpope/vim-rails",
		event = "BufReadPre",
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
	{
		"sindrets/diffview.nvim",
	},
	{
		"vim-ruby/vim-ruby",
		ft = "ruby",
	},
	{
		"tpope/vim-rails",
		ft = "ruby",
	},
	{
		"palekiwi/rspec-runner.nvim",
		opts = {
			defaults = {
				notify = false, -- set to `true` if using a notification plugin, such as `rcarriga/nvim-notify`
				cmd = { "bundle", "exec", "rspec" }, -- command that executes rspec
			},
			projects = { -- per project settings
				{
					path = "/home/gat/git/spabreaks/*", -- path to a project, must be a lua pattern
					cmd = { "docker-compose", "exec", "-it", "test", "bundle", "exec", "rspec" }, -- command
				},
			},
		},
	},
}
