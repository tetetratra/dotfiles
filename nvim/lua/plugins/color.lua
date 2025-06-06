-- Color
return {
  {
    'cocopon/iceberg.vim',
    config = function()
      vim.cmd('colorscheme iceberg')
      vim.cmd('highlight FloatBorder guibg=#242940 guifg=#242940 ctermbg=none')
    end,
  },
}
