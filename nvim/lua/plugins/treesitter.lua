return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"RRethy/nvim-treesitter-endwise",
		},
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({
				auto_install = true,
			})
			require("nvim-treesitter").install({
				"embedded_template",
				"html",
				"javascript",
				"json",
				"lua",
				"ruby",
				"terraform",
				"typescript",
				"yaml",
			})
			-- Modern Highlight & Regex fallback
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local ok, _ = pcall(vim.treesitter.start)
					if ok then
						vim.bo.syntax = "on"
					end
				end,
			})
			-- This tells Neovim to use the Treesitter engine for indent calculations
			vim.opt.indentexpr = "v:lua.vim.treesitter.indentexpr()"
			-- highlight = {
			-- 	enable = true,
			-- 	-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- 	-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- 	-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- 	-- Instead of true it can also be a list of languages
			-- 	additional_vim_regex_highlighting = true,
			-- },
			-- indent = {
			-- 	enable = true,
			-- },
			-- endwise = {
			-- 	enable = true,
			-- },
			-- 	textobjects = {
			-- 		select = {
			-- 			enable = true,
			-- 			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			-- 			keymaps = {
			-- 				-- You can use the capture groups defined in textobjects.scm
			-- 				["aa"] = "@parameter.outer",
			-- 				["ia"] = "@parameter.inner",
			-- 				["ab"] = "@block.outer",
			-- 				["ib"] = "@block.inner",
			-- 				["af"] = "@function.outer",
			-- 				["if"] = "@function.inner",
			-- 				["ac"] = "@class.outer",
			-- 				["ic"] = "@class.inner",
			-- 			},
			-- 		},
			-- 		move = {
			-- 			enable = true,
			-- 			set_jumps = true, -- whether to set jumps in the jumplist
			-- 			goto_next_start = {
			-- 				["]m"] = "@function.outer",
			-- 				["]]"] = "@class.outer",
			-- 			},
			-- 			goto_next_end = {
			-- 				["]M"] = "@function.outer",
			-- 				["]["] = "@class.outer",
			-- 			},
			-- 			goto_previous_start = {
			-- 				["[m"] = "@function.outer",
			-- 				["[["] = "@class.outer",
			-- 			},
			-- 			goto_previous_end = {
			-- 				["[M"] = "@function.outer",
			-- 				["[]"] = "@class.outer",
			-- 			},
			-- 		},
			-- 	},
			-- })
		end,
	},
}
