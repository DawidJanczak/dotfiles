vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 3
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Enable copying when selecting text
vim.opt.mouse = ""
-- Persist undos
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
-- Yanking from one window makes it available in another
vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.expandtab = true
	end,
})
