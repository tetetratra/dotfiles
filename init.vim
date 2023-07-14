" https://github.com/Shougo/dein.vim#basic-installation
" 時々 :call dein#update() でアップデートしよう
" deinが読み込まれない時は、:call dein#recache_runtimepath() をしてみよう
let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = fnamemodify('dein.vim', ':p')
  if !isdirectory(s:dein_dir)
    let s:dein_dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' .. substitute(
        \ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
endif

" https://github.com/Shougo/dein.vim#config-example
" Set dein base path (required)
let s:dein_base = '~/.cache/dein/'
" Set dein source path (required)
let s:dein_src = '~/.cache/dein/repos/github.com/Shougo/dein.vim'
" Set dein runtime path (required)
execute 'set runtimepath+=' .. s:dein_src
" Call dein initialization (required)
call dein#begin(s:dein_base)
call dein#add(s:dein_src)
" Your plugins go here:
let s:toml = $HOME .. '/.config/nvim/dein/toml/dein.toml'
call dein#load_toml(s:toml, {'lazy': 0})
" Finish dein initialization (required)
call dein#end()
if dein#check_install()
  call dein#install()
endif

lua require('options')
lua require('firenvim')

