return {
	"phaazon/hop.nvim",
	branch = "v2", -- hop v2 uses Lua API and is preferred
	config = function()
		require("hop").setup()

		vim.keymap.set("", "<leader>s", ":HopWord<CR>", { silent = true, desc = "Hop to word" })
		vim.keymap.set("", "<leader>S", ":HopChar2<CR>", { silent = true, desc = "Hop to 2-char" })
	end,
}
