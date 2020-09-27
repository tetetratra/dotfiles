
let hostname = substitute(system('hostname'), '\n', '', '')
if hostname == "red99" || hostname == "red30" || hostname == "lemon19"
  let g:python3_host_prog = expand('~/.linuxbrew/bin/python3')
else
  let g:python3_host_prog = $HOME . '/.pyenv/shims/python3'
endif

if has("gui_running") || has('nvim')
  " deinが読み込まれない時は、:call dein#recache_runtimepath() をしてみよう
  "dein Scripts-----------------------------
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
    call dein#load_toml(s:toml,      {'lazy': 0})
    " call dein#add('glacambre/firenvim', { 'hook_post_update': { _ -> firenvim#install(0) } }) " chromeでneovim起動させるプラグイン
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
  " End dein Scripts-------------------------
endif

if has("gui_running") || has('nvim')
  " ===== main =====
  language C " use english
  lang en_US.UTF-8 " https://teratail.com/questions/166889 より。アスタリスクレジスタ経由でクリップボード入れた文字が文字化けする対策
  " yankとmacのクリップボードを共有
  set clipboard=unnamed
  filetype plugin indent on
  syntax on
  set virtualedit=block " vim の矩形選択で文字が無くても右へ進める
  set showcmd
  set wildmenu " コマンドモードでのタブでのファイル名補完
  set number
  set cursorline
  set smartindent
  set visualbell
  set showmatch
  set wildmode=list:longest
  set list listchars=tab:>-
  set ambiwidth=double " ①みたいな記号を全角で表示
  set expandtab
  set tabstop=2
  set shiftwidth=2
  set backspace=indent,eol,start
  set incsearch
  set hlsearch " 検索結果をハイライト
  set title
  " set showtabline=2 " タブページを常に表示
  set laststatus=2 " ステータスラインを常に表示
  " set laststatus=0 " ステータスラインを常に非表示
  set noswapfile
  set scrolloff=5 " スクロールする時に下が見えるようにする
  set matchpairs& matchpairs+=<:> " 対応括弧に<と>のペアを追加
  set showmatch " 対応括弧をハイライト表示する
  set nowrap
  set wildmenu " コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
  set smartcase " 小文字のみで検索したときに大文字小文字を無視する
  set wildignorecase
  set wildmode=list,full
  set whichwrap=b,s,h,l,<,>,[,] " 行頭行末の左右移動で行をまたぐようにする
  set backspace=indent,eol,start " Backspaceの影響範囲に制限を設けないようにする
  let g:tex_conceal = '' " texの数式を特殊文字に置き換えるのをしない
  set conceallevel=0 " conceal機能を無効
  " very magic
  nnoremap / /\v
  " 自然な正規表現
  nmap / /\v
  " grep検索の実行後にQuickFix Listを表示する
  autocmd QuickFixCmdPost *grep* cwindow
  nnoremap J :cnext<CR>
  nnoremap K :cprevious<CR>
  " xで消したときにyankが書き換わらないようにする gT
  noremap PP "0p
  noremap x "_x
  " fold系
  set foldmethod=indent
  " 最後のカーソル位置を復元する
  if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  endif
  if has("nvim")
    set mouse=a
  endif
  if !exists('loaded_matchit')
    " matchitを有効化
    runtime macros/matchit.vim
  endif
  " 標準ファイラーは使わないからOFF
  let g:loaded_netrw             = 1
  let g:loaded_netrwPlugin       = 1
  let g:loaded_netrwSettings     = 1
  let g:loaded_netrwFileHandlers = 1
  " ====== mapping ======
  set notimeout
  set ttimeout
  set timeoutlen=100
  " === insert ===
  inoremap <silent> jj <ESC>
  imap <C-a> <C-o>:call <SID>home()<CR>
  function! s:home()
    let start_column = col('.')
    normal! ^
    if col('.') == start_column
      normal! 0
    endif
    return ''
  endfunction
  imap <C-e> <End>
  imap <C-d> <BackSpace>
  imap <C-h> <Left>
  imap <C-k> <Up>
  imap <C-j> <Down>
  imap <C-l> <Right>
  imap <TAB> <C-n>
  imap <S-TAB> <C-p>
  " === normal ===
  nnoremap <Esc> :noh<CR>
  nnoremap s <Nop>
  " 検索で下にいってしまうのを抑える
  " autocmd VimEnter * nnoremap * *N
  " autocmd VimEnter * vnoremap * *N<esc>
  " 貼り付けたテキストの末尾へ自動的に移動
  nnoremap <silent> p p`]
  " <Space>wを押してファイルを保存
  nnoremap <Space>w :w<CR>
  nnoremap <Space>q :bd<CR>
  " 候補が複数ある場合は一覧表示
  nnoremap <C-]> g<C-]>
  " === buffer系 ===
  " buffer移動
  nnoremap <silent> <C-h> :bprev<CR>
  nnoremap <silent> <C-l> :bnext<CR>
  " 保存してなくてもバッファ切り替えOK
  set hidden
  " === window系 ===
  " window移動していく
  " autocmd VimEnter * noremap <C-o> <C-w>w
  " window分割、入れ替え、作成、移動
  nnoremap sh :<C-u>sp<CR>
  nnoremap sv :<C-u>vs<CR>
  " === visual系 ===
  " visualでラストの改行はデフォルトでは含めないようにする
  vnoremap $ $h
  " 貼り付けたテキストの末尾へ自動的に移動
  vnoremap <silent> y y`]
  vnoremap <silent> p p`]
  " === comand系 ===
  cnoremap <C-e> <End>
  cnoremap <C-a> <Home>
  " === そのた ===
  " <F1> => nerdtree toggle
  " <F2> => tag list
  " <F3> => marks
  " <F4> => color mark
  noremap  <F5> zm
  noremap  <F6> zr
  noremap  <F7> <nop>
  noremap  <F8> <nop>
  noremap  <F9> <nop>
  noremap <F10> <esc>:set wrap!<CR>
  noremap <F11> <nop>
  noremap <F12> <nop>
else " raw vim
  " === main ===
  set nocompatible " vi互換モードoff
  filetype plugin indent on
  syntax on
  set virtualedit=block " vim の矩形選択で文字が無くても右へ進める
  set showcmd
  set wildmenu " コマンドモードでのタブでのファイル名補完
  set number
  set cursorline
  set smartindent
  set visualbell
  set expandtab
  set tabstop=2
  set hlsearch " 検索結果をハイライト
  set title
  set noswapfile
  set scrolloff=5 " スクロールする時に下が見えるようにする
  set matchpairs& matchpairs+=<:> " 対応括弧に<と>のペアを追加
  set showmatch " 対応括弧をハイライト表示する
  set nowrap
  set wildmenu " コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
  set smartcase " 小文字のみで検索したときに大文字小文字を無視する
  set whichwrap=b,s,h,l,<,>,[,] " 行頭行末の左右移動で行をまたぐようにする
  set backspace=indent,eol,start " Backspaceの影響範囲に制限を設けないようにする
  " 自然な正規表現
  nmap / /\v
  " xで消したときにyankが書き換わらないようにする gT
  noremap PP "0p
  noremap x "_x
  " 最後のカーソル位置を復元する
  if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  endif
  " === mapping ===
  inoremap <silent> jj <ESC>
  imap <C-a> <C-o>:call <SID>home()<CR>
  function! s:home()
    let start_column = col('.')
    normal! ^
    if col('.') == start_column
      normal! 0
    endif
    return ''
  endfunction
  imap <C-e> <End>
  imap <C-d> <BackSpace>
  imap <C-h> <Left>
  imap <C-k> <Up>
  imap <C-j> <Down>
  imap <C-l> <Right>
  imap <TAB> <C-n>
  imap <S-TAB> <C-p>
  " 検索で下にいってしまうのを抑える
  " nnoremap * *N
  " vnoremap * *N<esc>
  " 貼り付けたテキストの末尾へ自動的に移動
  nnoremap <silent> p p`]
  " <Space>wを押してファイルを保存
  nnoremap <Space>w :w<CR>
  nnoremap <Space>q :bd<CR>
  " :C コマンドでメッセージをクリップボードにコピー
  " https://ja.stackoverflow.com/questions/40769
  command C let @+ = execute("1messages")
  " === color ===
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * hi Normal ctermbg=235 "挿入モード時の色
    autocmd InsertLeave * hi Normal ctermbg=0 "通常モード時の色
  augroup END
endif

" ===== color ====
if has("gui_running")
  colorscheme iceberg " https://github.com/cocopon/iceberg.vim.git
elseif has('nvim')
  " colorscheme srcery
  colorscheme iceberg
else
  " colorscheme forest-night
  colorscheme iceberg
endif
if has("gui_running") || has('nvim')
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  " highlight LineNr ctermbg=none
  highlight Folded ctermbg=none
  highlight EndOfBuffer ctermbg=none
  autocmd ColorScheme * highlight Visual ctermbg=242
  highlight Comment ctermfg=245
  " 補完の色
  hi Pmenu ctermbg=234 ctermfg=105
  hi PmenuSel ctermbg=234 ctermfg=45
  " タブの色とか
  hi TabLineSel ctermfg=White ctermbg=25
  hi TabLine ctermfg=White ctermbg=235
  hi TabLineFill ctermfg=242
  " 何故か下の方で設定しないと反映されない
  highlight Visual guibg=#006080
  autocmd ColorScheme * highlight Visual guibg=#006080
  " フロートwhindowの文字の色を黒、背景色を緑に変更
  " highlight NormalFloat guifg=234 guibg=105
endif

