-- 言語固有
return {
  { 'tpope/vim-rails', ft = 'ruby' },
  { 'joker1007/vim-ruby-heredoc-syntax', ft = 'ruby' },
  { 'pocke/rbs.vim', ft = 'ruby' },
  {
    'maxmellon/vim-jsx-pretty',
    ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    config = function()
      vim.cmd([[
    let g:vim_jsx_pretty_colorful_config = 1
    let g:vim_jsx_pretty_highlight_close_tag = 1
    ]])
    end,
  },
  { 'rhysd/vim-crystal', ft = 'crystal' },
  { 'slim-template/vim-slim', ft = 'slim' },
  {
    'plasticboy/vim-markdown',
    ft = 'markdown',
    config = function()
      vim.cmd([[
    " markdwonの折りたたみ無効化
    set nofoldenable
    let g:vim_markdown_folding_disabled = 1
    " markdown書くようの設定
    autocmd FileType markdown inoremap <Tab> <Esc>>>A
    autocmd FileType markdown inoremap <S-Tab> <Esc><<A
    let g:vim_markdown_conceal = 0
    ]])
    end,
  },
  {
    'mattn/emmet-vim',
    ft = 'html',
    config = function()
      vim.cmd([[
    let g:user_emmet_leader_key='<C-Z>'
    " let g:user_emmet_install_global = 0
    " auletocmd FileType html,css,typescriptreact EmmetInstall
    ]])
    end,
  },
  { 'cespare/vim-toml', ft = 'toml' },
  { 'mechatroner/rainbow_csv', ft = 'csv' },
  { 'aklt/plantuml-syntax', ft = 'plantuml' },
  { 'mtdl9/vim-log-highlighting' },
  { 'hashivim/vim-terraform' },
}
