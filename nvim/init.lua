require("config.lazy")
require("keymaps")
require("options")

local utils = require("utils")

vim.api.nvim_create_user_command("ReloadConfig", function()
	utils.reload_config()
end, {})

local find_template_in_views = function()
	local filename = vim.fn.expand("%:t:r:r"):gsub("^_", "")
	local regex = "(render|partial:)[\\s(]?['\"][^\\s]*" .. filename .. "['\"]\\B"
	require("telescope.builtin").grep_string({ search_dirs = { "app" }, search = regex, use_regex = true })
end

vim.keymap.set("n", "<leader>fv", find_template_in_views)

require("conform").setup({

	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 3000,
	},
	formatters = {
		sqlfluff = {
			command = "sqlfluff",
			args = { "fix", "--disable-progress-bar", "-" },
			stdin = true,
		},
		erb_lint = {
			stdin = false,
			tmpfile_format = ".conform.$RANDOM.$FILENAME",
			command = "erb_lint",
			args = { "--autocorrect", "$FILENAME" },
			ignore_stderr = true,
		},
		terraform_fmt = {
			command = "terraform",
			args = { "fmt", "-" },
			-- To avoid formatting on save for every file
			stdin = true,
			-- To run it only on specific filetypes or with specific names
			filetypes = { "terraform", "hcl" },
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		ruby = { "rubocop" },
		eruby = { "erb_lint" },
		sql = { "sqlfluff" },
		typescript = { "prettier" },
		terraform = { "terraform_fmt" },
	},
})

require("nvim-autopairs").setup({})

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			--elseif luasnip.expand_or_locally_jumpable() then
			--luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			--elseif luasnip.locally_jumpable(-1) then
			--luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

local file_gh_url_to_clipboard = function()
	local file_name = vim.fn.expand("%")
	local ln = vim.api.nvim_win_get_cursor(0)[1]
	local hash_command = "git log -n 1 --pretty=format:'%H'"
	local repo_command = "git remote -v"

	local handle = io.popen(hash_command)
	if handle == nil then
		return
	end

	local hash = handle:read("*a")
	handle:close()

	handle = io.popen(repo_command)
	if handle == nil then
		return
	end

	local repo_out = handle:read("*a")
	handle:close()

	local repo = string.match(repo_out, "git@github.com:([^ ]+)")

	local url = "https://github.com/" .. repo .. "/blob/" .. hash .. "/" .. file_name .. "#L" .. ln

	vim.fn.setreg("+", url)
end

vim.keymap.set("n", "<leader>of", file_gh_url_to_clipboard)
vim.keymap.set("n", "]q", ":cnext<CR>")
vim.keymap.set("n", "[q", ":cprev<CR>")

-- Vim-rails sets all Yaml files to eruby, revert that
vim.api.nvim_create_autocmd("FileType", {
	pattern = "eruby.yaml",
	callback = function()
		vim.bo.filetype = "yaml"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.textwidth = 100
		vim.opt_local.formatoptions:append("t")
	end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.turbo_stream.erb",
	callback = function()
		vim.bo.filetype = "eruby"
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "eruby",
	callback = function()
		vim.bo.indentexpr = ""
		vim.bo.indentkeys = ""
		vim.cmd("setlocal indentexpr=GetHtmlIndent()")
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	callback = function()
		-- Remove dash as a re-indent trigger
		vim.bo.indentkeys = "!^F,o,O,0},0],<:>,0"
	end,
})
