local modules = {}
local dir = debug.getinfo(1, 'S').source:match('@(.*/)')
if dir then
  for name, type in vim.fs.dir(dir) do
    if type == 'file' and name:sub(-4) == '.lua' and name ~= 'init.lua' then
      table.insert(modules, 'plugins.' .. name:sub(1, -5))
    end
  end
  table.sort(modules)
end

local plugins = {}
for _, m in ipairs(modules) do
  local ok, items = pcall(require, m)
  if ok then
    vim.list_extend(plugins, items)
  end
end

return plugins
