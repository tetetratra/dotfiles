-- 検索・置換
return {
  {
    'othree/eregex.vim',
    config = function()
      vim.cmd([[
    let g:eregex_default_enable = 0
    nnoremap ? :M/
    ]])
    end,
  },
  {
    'henrik/vim-indexed-search',
    config = function()
      vim.cmd([[
    let g:indexed_search_dont_move = 1
    let g:indexed_search_numbered_only = 1
    let g:indexed_search_shortmess = 1
    ]])
    end,
  },
}
