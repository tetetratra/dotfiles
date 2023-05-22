" deinの初回インストール時はシェルスクリプトの実行が必要 https://github.com/Shougo/dein.vim
" 時々 :call dein#update() でアップデートしよう
if has("gui_running") || has('nvim')
  " deinが読み込まれない時は、:call dein#recache_runtimepath() をしてみよう
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

  if dein#check_install() " install not installed plugins on startup.
      call dein#install()
  endif

  lua require('options')
else

endif

