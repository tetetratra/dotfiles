if has("gui_running") || has('nvim')
  " deinが読み込まれない時は、:call dein#recache_runtimepath() をしてみよう
  if &compatible
    set nocompatible
  endif
  " Required:
  set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
  " Required:
  if dein#load_state($HOME . '/.cache/dein')
    call dein#begin($HOME . '/.cache/dein')
    let s:toml_dir  = $HOME . '/.config/nvim/dein/toml'
    let s:toml      = s:toml_dir . '/dein.toml'
    call dein#load_toml(s:toml, {'lazy': 0})
    " Let dein manage dein
    " Required:
    call dein#add($HOME . '/.cache/dein/repos/github.com/Shougo/dein.vim')
    " Required:
    call dein#end()
    call dein#save_state()
  endif
  " Required:
  filetype plugin indent on
  syntax enable
  " If you want to install not installed plugins on startup.
  if dein#check_install()
    call dein#install()
  endif
endif

if has("gui_running") || has('nvim') " macvim
  source ~/.vimrc_main
else " raw vim
  source ~/.vimrc_mini
  colorscheme desert
endif

