local lsp_flags = {
	debounce_text_changes = 150,
}

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	local opts = { buffer = bufnr, noremap = true, silent = true }

	-- Mappings (converted from vim.api.nvim_buf_set_keymap)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
	vim.keymap.set("v", "<leader>a", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

	-- Document Highlighting
	if client.server_capabilities.documentHighlightProvider then
		local group = vim.api.nvim_create_augroup("document_highlight", { clear = false })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			group = group,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = bufnr,
			group = group,
			callback = vim.lsp.buf.clear_references,
		})

		vim.api.nvim_set_hl(0, "LspReferenceText", { bold = true, bg = "#45403d" })
		vim.api.nvim_set_hl(0, "LspReferenceRead", { bold = true, bg = "#45403d" })
		vim.api.nvim_set_hl(0, "LspReferenceWrite", { bold = true, bg = "#45403d" })
	end
end

return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			--- Add additional capabilities supported by nvim-cmp
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local default_config = {
				on_attach = on_attach,
				flags = lsp_flags,
				capabilities = capabilities,
				trace = {
					server = "debug",
				},
			}

			-- TODO bring back yamlls
			-- vim.lsp.config.yamlls = default_config

			-- Servers from the loop in init.lua
			vim.lsp.config.elmls = default_config
			vim.lsp.config.stimulus_ls = default_config
			vim.lsp.config.eslint = default_config
			vim.lsp.config.gopls = default_config
			vim.lsp.config.ts_ls = default_config

			-- Specific server configurations
			vim.lsp.config.diagnosticls = {
				filetypes = { "elmls", "javascript", "typescript", "css", "go" },
			}

			vim.lsp.config.ruby_lsp = {
				on_attach = on_attach,
				capabilities = capabilities,
				flags = lsp_flags,
			}

			-- Enable servers
			vim.lsp.enable("herb_ls")
			vim.lsp.enable("elmls")
			vim.lsp.enable("stimulus_ls")
			vim.lsp.enable("eslint")
			vim.lsp.enable("gopls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("diagnosticls")
			vim.lsp.enable("ruby_lsp")
		end,
	},
}
