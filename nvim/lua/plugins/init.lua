local modules = {
  'plugins.base',
  'plugins.color',
  'plugins.fuzzy',
  'plugins.file',
  'plugins.completion',
  'plugins.operation',
  'plugins.search',
  'plugins.mark',
  'plugins.git',
  'plugins.languages',
  'plugins.others',
  'plugins.copilot',
}

local plugins = {}
for _, m in ipairs(modules) do
  local ok, items = pcall(require, m)
  if ok then
    vim.list_extend(plugins, items)
  end
end

return plugins
