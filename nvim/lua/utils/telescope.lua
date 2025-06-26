local M = {}

function M.find_template_in_views()
	local filename = vim.fn.expand("%:t:r:r"):gsub("^_", "")
	local regex = "(render|partial:)[\\s(]?['\"][^\\s]*" .. filename .. "['\"]\\B"
	require("telescope.builtin").grep_string({
		search_dirs = { "app" },
		search = regex,
		use_regex = true,
	})
end

return M
