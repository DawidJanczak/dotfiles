local M = {}

function M.reload_config()
  for name,_ in pairs(package.loaded) do
    if name:match("^plugins") or name:match("^lua") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
end

return M
