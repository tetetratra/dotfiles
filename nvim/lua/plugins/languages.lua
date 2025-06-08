-- 言語固有
return {
  { 'tpope/vim-rails', ft = 'ruby' },
  { 'joker1007/vim-ruby-heredoc-syntax', ft = 'ruby' },
  { 'pocke/rbs.vim', ft = 'ruby' },
  {
    'maxmellon/vim-jsx-pretty',
    ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    config = function()
      vim.g.vim_jsx_pretty_colorful_config = 1
      vim.g.vim_jsx_pretty_highlight_close_tag = 1
    end,
  },
  { 'rhysd/vim-crystal', ft = 'crystal' },
  { 'slim-template/vim-slim', ft = 'slim' },
  {
    'plasticboy/vim-markdown',
    ft = 'markdown',
    config = function()
      vim.cmd('set nofoldenable') -- markdwonの折りたたみ無効化
      vim.g.vim_markdown_folding_disabled = 1
      -- markdown書くようの設定
      vim.cmd('autocmd FileType markdown inoremap <Tab> <Esc>>>A')
      vim.cmd('autocmd FileType markdown inoremap <S-Tab> <Esc><<A')
      vim.g.vim_markdown_conceal = 0
    end,
  },
  {
    'mattn/emmet-vim',
    ft = 'html',
    config = function()
      vim.g.user_emmet_leader_key = '<C-Z>'
    end,
  },
  { 'cespare/vim-toml', ft = 'toml' },
  { 'mechatroner/rainbow_csv', ft = 'csv' },
  { 'aklt/plantuml-syntax', ft = 'plantuml' },
  { 'mtdl9/vim-log-highlighting' },
  { 'hashivim/vim-terraform' },
}
