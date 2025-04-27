vim.keymap.set('n', '<leader>vc', function()
  require('telescope.builtin').find_files({
    prompt_title = "Neovim Config",
    cwd = "~/.config/nvim",
  })
end, { desc = "Browse Neovim config" })

vim.keymap.set('n', '<leader><leader>', '<C-^>', { desc = "Switch to previous buffer" })

vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>', { desc = "Clear search highlight" })

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-p>', function()
  local ok, git_root = pcall(vim.fn.systemlist, "git rev-parse --show-toplevel")
  if ok and git_root[1] and git_root[1] ~= "" then
    builtin.find_files({ cwd = git_root[1] })
  else
    builtin.find_files()
  end
end, { desc = "Find Project Files" })
