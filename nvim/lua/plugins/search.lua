-- 検索・置換
return {
  {
    'othree/eregex.vim',
    config = function()
      vim.g.eregex_default_enable = 0
      vim.api.nvim_set_keymap('n', '?', ':M/', { noremap = true, silent = true })
    end,
  },
  {
    'henrik/vim-indexed-search',
    config = function()
      vim.g.indexed_search_dont_move = 1
      vim.g.indexed_search_numbered_only = 1
      vim.g.indexed_search_shortmess = 1
    end,
  },
}
