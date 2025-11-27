-- Color
return {
  {
    'cocopon/iceberg.vim',
    config = function()
      vim.cmd('colorscheme iceberg')
      vim.cmd('highlight FloatBorder guibg=#242940 guifg=#242940 ctermbg=none')
    end,
  },
  {
    'cormacrelf/dark-notify', -- ダークモード切り替えを検知して :set bg=dark/light を自動で切り替える
    config = function()
      require('dark_notify').run()
    end,
  }
}
