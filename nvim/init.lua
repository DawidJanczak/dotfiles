require("config.lazy")
require("keymaps")
require("options")

-- TODO
-- ctrl + p
-- surround plugin

-- vim.opt.runtimepath:prepend("~/.vim")
-- vim.opt.packpath = vim.opt.runtimepath:get()
-- vim.cmd("source ~/.vimrc")
-- require('telescope').load_extension('yaml_schema')

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.keymap.set('n', '<leader>g', ":Telescope grep_string word_match=-w<cr>")
vim.keymap.set('n', '<leader>ga', ":Telescope grep_string word_match=-w search_dirs=app<cr>")
vim.keymap.set('n', '<leader>G', ":Telescope live_grep")

local find_template_in_views = function()
  local filename = vim.fn.expand("%:t:r:r"):gsub("^_", "")
  local regex = "(render|partial:)[\\s(]?[\'\"][^\\s]*" .. filename .. "[\'\"]\\B"
  require'telescope.builtin'.grep_string({search_dirs = { "app" }, search = regex, use_regex=true })
end

vim.keymap.set('n', '<leader>fv', find_template_in_views)

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('v', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

  -- Enable on 0.10
  -- vim.lsp.buf.inlay_hint(0, true)

  if client.server_capabilities.documentHighlightProvider then
    vim.cmd [[
      hi LspReferenceText gui=bold guibg=#45403d
      hi LspReferenceRead gui=bold guibg=#45403d
      hi LspReferenceWrite gui=bold guibg=#45403d

      augroup document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "elmls", "stimulus_ls", "eslint", "gopls", "ts_ls", "yamlls" }
vim.lsp.set_log_level(2)
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    trace = {
      server = 'debug'
    }
  }
end

nvim_lsp.diagnosticls.setup {
  filetypes = { "elmls", "javascript", "typescript", "css", "go" },
}

require("conform").setup({
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 3000,
  },
  formatters = {
    sqlfluff = {
      command = "sqlfluff",
      args = { "fix", "--disable-progress-bar", "-" },
      stdin = true
    }
  },
  formatters_by_ft = {
    ruby = { "rubocop" },
    -- eruby = { "erb_format" },
    sql = { "sqlfluff" },
    typescript = { "prettier" }
  },
})

-- Ruby-lsp textDocument/diagnostic support until 0.10.0 is released
_timers = {}
local function setup_diagnostics(client, buffer)
  if require("vim.lsp.diagnostic")._enable then
    return
  end

  local diagnostic_handler = function()
    local params = vim.lsp.util.make_text_document_params(buffer)
    client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
      if err then
        local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
        vim.lsp.log.error(err_msg)
      end
      local diagnostic_items = {}
      if result then
        diagnostic_items = result.items
      end
      vim.lsp.diagnostic.on_publish_diagnostics(
        nil,
        vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
        { client_id = client.id }
      )
    end)
  end

  diagnostic_handler() -- to request diagnostics on buffer when first attaching

  vim.api.nvim_buf_attach(buffer, false, {
    on_lines = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
      _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
    end,
    on_detach = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
    end,
  })
end

require("nvim-autopairs").setup {}

require("lspconfig").ruby_lsp.setup({
  on_attach = function(client, buffer)
    on_attach(client, buffer)
    setup_diagnostics(client, buffer)
  end,
})

-- Hook up yaml companion to yamlLS
--local cfg = require("yaml-companion").setup()
--require("lspconfig").yamlls.setup(cfg)

-- Treesitter config
require('nvim-treesitter.configs').setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  }
}

-- Configure nvim-csp
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      --elseif luasnip.expand_or_locally_jumpable() then
        --luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      --elseif luasnip.locally_jumpable(-1) then
        --luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

local file_gh_url_to_clipboard = function()
  local file_name = vim.fn.expand("%")
  local ln = vim.api.nvim_win_get_cursor(0)[1]
  local hash_command = "git log -n 1 --pretty=format:'%H'"
  local repo_command = "git remote -v"

  local handle = io.popen(hash_command)
  if handle == nil then return end

  local hash = handle:read("*a")
  handle:close()

  handle = io.popen(repo_command)
  if handle == nil then return end

  local repo_out = handle:read("*a")
  handle:close()

  local repo = string.match(repo_out, "git@github.com:([^ ]+)")

  local url = "https://github.com/" .. repo .. "/blob/" .. hash .. "/" .. file_name .. "#L" .. ln

  vim.fn.setreg("+", url)
end

vim.keymap.set('n', '<leader>of', file_gh_url_to_clipboard)
vim.keymap.set('n', ']q', ':cnext<CR>')
vim.keymap.set('n', '[q', ':cprev<CR>')
