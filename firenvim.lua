-- dein.tomlの設定は、options.luaよりも先に読み込まれてしまうので、firenvimの設定はこちらで読み込んで上書きする

if vim.g.started_by_firenvim == true then
  -- デフォルトでfirenvimが動くのをoffにする
  -- Chromeのfirenvimのショートカットは alt + V が良さげ
  vim.g.firenvim_config = {
    localSettings = {
      [".*"] = {
        selector = "",
        priority = 0,
      }
    },
  }

  vim.o.showtabline = 0
  vim.o.laststatus = 0
  vim.cmd('set filetype=markdown')
  vim.api.nvim_set_keymap('n', '<Space>w', ':wq!<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<Space>q', ':wq!<CR>', { silent = true })
  vim.cmd('set guifont=Monaco\\ M:h22')
end
