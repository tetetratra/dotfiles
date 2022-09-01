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
endif

let rawvim = !(has("gui_running") || has('nvim'))
if rawvim
  colorscheme desert
endif

" ===== main =====
" vi互換モードoff
set nocompatible
" English
language C
" https://teratail.com/questions/166889 アスタリスクレジスタ経由でクリップボード入れた文字が文字化けする対策
lang en_US.UTF-8
" yankとmacのクリップボードを共有
set clipboard=unnamed
filetype plugin indent on
syntax enable
syntax on
" vim の矩形選択で文字が無くても右へ進める
" set virtualedit=block
set showcmd
set number
set cursorline
set smartindent
set visualbell
set list listchars=tab:>-
" ①みたいな記号を全角で表示
set ambiwidth=double
set expandtab
set tabstop=8
set shiftwidth=2
autocmd FileType c setlocal sw=4 sts=4 ts=4 et
set incsearch
" 検索結果をハイライト
set hlsearch
set title
" ステータスラインを常に表示
set laststatus=2
set noswapfile
" スクロールする時に下が見えるようにする
set scrolloff=5
" 対応括弧に<と>のペアを追加
set matchpairs& matchpairs+=<:>
" 対応括弧をハイライト表示する
set showmatch
set nowrap
" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu
set wildmode=list:longest,list:full
" 小文字のみで検索したときに大文字小文字を無視する
set smartcase
set wildignorecase
" 行頭行末の左右移動で行をまたぐようにする
set whichwrap=b,s,h,l,<,>,[,]
" Backspaceの影響範囲に制限を設けないようにする
set backspace=indent,eol,start
" texの数式を特殊文字に置き換えるのをしない
let g:tex_conceal = ''
" conceal機能を無効
set conceallevel=0
if rawvim " vim以外ではeregexの正規表現を使うので
  " very magic
  nnoremap / /\v
  nnoremap ? ?\v
endif
" visualモードで選択範囲を検索 https://vim-jp.org/vimdoc-ja/visual.html#visual-search
vmap X y/<C-R>"<CR>
" grep検索の実行後にQuickFix Listを表示する
autocmd QuickFixCmdPost *grep* cwindow
nnoremap J :cnext<CR>
nnoremap K :cprevious<CR>
noremap p "_dp
vnoremap p "_dp
" xで消したときにyankが書き換わらないようにする
noremap x "_x
set foldmethod=indent
" 最後のカーソル位置を復元する
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal! g'\"" |
\ endif
if has("nvim")
  set mouse=a
endif
if !exists('loaded_matchit')
  " matchitを有効化
  runtime macros/matchit.vim
endif
if rawvim
  " 標準ファイラーは使わないからOFF
  let g:loaded_netrw             = 1
  let g:loaded_netrwPlugin       = 1
  let g:loaded_netrwSettings     = 1
  let g:loaded_netrwFileHandlers = 1
endif

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
" 貼り付けたテキストの末尾へ自動的に移動
nnoremap <silent> p p`]
" <Space>wを押してファイルを保存
nnoremap <Space>w :w<CR>
nnoremap <Space>q :q<CR>
" nnoremap <Space>q :bd<CR>
" 候補が複数ある場合は一覧表示
nnoremap <C-]> g<C-]>
" ファイル名をyank
nnoremap <Space>c <esc>:let @+ = expand('%:t')<CR>
" パスとファイル名をyank
nnoremap <Space>C <esc>:let @+ = expand("%")<CR>
nnoremap t :tabnew<CR>
nnoremap T :tabnew #<CR>
nnoremap J V:m '>+1<CR>
nnoremap K V:m '<-2<CR>
nnoremap E <esc>:e!<CR>

" === buffer系 ===
" 保存してなくてもバッファ切り替えOK
set hidden

" === tab系 ===
" tab移動
nnoremap <silent> <C-h> :tabprevious<CR>
nnoremap <silent> <C-l> :tabnext<CR>
nnoremap <lt> :-tabm<CR>
nnoremap >    :+tabm<CR>
nnoremap yt :tab split<CR>

nmap <D-1> <esc>1gt<CR>
nmap <D-2> <esc>2gt<CR>
nmap <D-3> <esc>3gt<CR>
nmap <D-4> <esc>4gt<CR>
nmap <D-5> <esc>5gt<CR>
nmap <D-6> <esc>6gt<CR>
nmap <D-7> <esc>7gt<CR>
nmap <D-8> <esc>8gt<CR>
nmap <D-9> <esc>:tablast<CR>
nmap 1<Space> <esc>1gt<CR>
nmap 2<Space> <esc>2gt<CR>
nmap 3<Space> <esc>3gt<CR>
nmap 4<Space> <esc>4gt<CR>
nmap 5<Space> <esc>5gt<CR>
nmap 6<Space> <esc>6gt<CR>
nmap 7<Space> <esc>7gt<CR>
nmap 8<Space> <esc>8gt<CR>
nmap 9<Space> <esc>:tablast<CR>
set showtabline=2

" tabsをクリップボードに入れる TODO: grep, awkする
command! Tabscopy redi @* | silent tabs | redi end

" === window系 ===
noremap <Space>e <C-w>w
noremap <Space>7 <C-w>K<CR>
noremap <Space>8 <C-w>x<CR>
noremap <Space>9 <C-w>H<CR>

" === visual系 ===
" visualでラストの改行はデフォルトでは含めないようにする
" vnoremap $ $h
" 貼り付けたテキストの末尾へ自動的に移動
vnoremap <silent> y y`]
vnoremap <silent> p p`]
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" === comand系 ===
cabbrev t tabnew
cabbrev w set wrap!

cnoremap <C-e> <End>
cnoremap <C-a> <Home>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

" == color ==
" https://qiita.com/delphinus/items/a202d0724a388f6cdbc3
set termguicolors " ターミナルでも True Color を使えるようにする
set winblend=10 " 任意の floating windows を半透明に表示する
highlight FloatBorder ctermbg=None ctermfg=None

highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight Folded ctermbg=none
highlight EndOfBuffer ctermbg=none
highlight Visual ctermbg=242
highlight Visual guibg=#006080
highlight Comment ctermfg=245
highlight Pmenu ctermbg=234 ctermfg=105
highlight PmenuSel ctermbg=234 ctermfg=45
highlight Search guibg=darkcyan guifg=cyan ctermbg=darkcyan ctermfg=cyan

autocmd BufNewFile,BufRead *.mlisp set filetype=lisp
let lisp_rainbow = 1
