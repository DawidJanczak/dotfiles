local map = vim.keymap.set

map("n", "<leader>vc", function()
	require("telescope.builtin").find_files({
		prompt_title = "Neovim Config",
		cwd = "~/.config/nvim",
	})
end, { desc = "Browse Neovim config" })

map("n", "<leader><leader>", "<C-^>", { desc = "Switch to previous buffer" })

map("n", "<Esc><Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

local builtin = require("telescope.builtin")

map("n", "<C-p>", function()
	local ok, git_root = pcall(vim.fn.systemlist, "git rev-parse --show-toplevel")
	if ok and git_root[1] and git_root[1] ~= "" then
		builtin.find_files({ cwd = git_root[1] })
	else
		builtin.find_files()
	end
end, { desc = "Find Project Files" })

map("n", "<leader><tab>", function()
	require("telescope.builtin").buffers()
end, { noremap = true, silent = true, desc = "Find Buffers" })

map("n", "<leader>dv", function()
	local view = require("diffview.lib").get_current_view()
	if view then
		vim.cmd("DiffviewClose")
	else
		vim.cmd("DiffviewOpen")
	end
end, { desc = "Toggle Diffview" })

map("n", "<leader>dm", function()
	local lib = require("diffview.lib")
	local view = lib.get_current_view()
	if view then
		vim.cmd("DiffviewClose")
	else
		vim.cmd("DiffviewOpen origin/master")
	end
end, { desc = "Toggle diff with origin/master" })

local opts = { noremap = true, silent = true }

-- Move between splits using Ctrl-h/j/k/l
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

local ts_utils = require("utils.telescope")

vim.keymap.set("n", "<leader>fv", ts_utils.find_template_in_views)
