-- ===== main =====
-- vi互換モードoff
vim.o.compatible = false
-- English
vim.cmd('language C')
-- 読み込み時の文字コードの候補を指定
vim.cmd('set fileencodings=utf-8,sjis,euc-jp')
-- https://teratail.com/questions/166889 アスタリスクレジスタ経由でクリップボード入れた文字が文字化けする対策
vim.env.LANG = 'en_US.UTF-8'
-- yankとmacのクリップボードを共有
vim.o.clipboard = 'unnamed'
vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')
vim.cmd('syntax on')

-- ファイル保存時の確認を無効化
vim.o.confirm = false
-- showcmdを有効にする
vim.o.showcmd = true
-- 行番号を表示する
vim.o.number = true
-- カーソル行を強調表示する
vim.o.cursorline = true
-- インデントをスマートにする
vim.o.smartindent = true
-- ビジュアルベルを使用する
vim.o.visualbell = true
-- タブを特殊文字で表示する
vim.o.list = true
vim.o.listchars = "tab:>-"
-- single: 「まるいち」のような記号が半角になってしまう
-- double: 全角文字が現れたときに表示が崩れる (iterm + tmux + neovim)
vim.o.ambiwidth = "double"
-- タブをスペースに展開する
vim.o.expandtab = true
-- タブ幅を8に設定する
vim.o.tabstop = 8
-- インデント幅を2に設定する
vim.o.shiftwidth = 2
-- FileTypeがcのときにローカルな設定を適用する
vim.cmd('autocmd FileType c setlocal sw=4 sts=4 ts=4 et')
-- 検索時にインクリメンタル検索を有効にする
vim.o.incsearch = true
-- 検索結果をハイライト表示する
vim.o.hlsearch = true
-- タイトルを設定する
vim.o.title = true
-- ステータスラインを常に表示する
vim.o.laststatus = 2
-- スワップファイルを使用しない
vim.o.swapfile = false
-- スクロール時に下部が見えるようにする
vim.o.scrolloff = 7
-- 対応する括弧に<と>のペアを追加する
vim.o.matchpairs = vim.o.matchpairs .. ",<:>"
-- 対応する括弧をハイライト表示する
vim.o.showmatch = true
-- ラップしないようにする
vim.o.wrap = false
-- コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
vim.o.wildmenu = true
-- 補完モードの動作設定を調整する
vim.o.wildmode = "list:longest,list:full"
-- 小文字のみで検索した場合に大文字小文字を無視する
vim.o.smartcase = true
vim.o.wildignorecase = true
-- 行頭行末の左右移動で行をまたぐようにする
vim.o.whichwrap = "b,s,h,l,<,>,[,]"
-- Backspaceの影響範囲に制限を設けないようにする
vim.o.backspace = "indent,eol,start"
-- texの数式を特殊文字に置き換えないようにする
vim.g.tex_conceal = ''
-- conceal機能を無効にする
vim.o.conceallevel = 0
-- 折りたたみメソッドをインデントベースに設定する
vim.o.foldmethod = 'indent'
-- grep検索の実行後にQuickFix Listを表示する
vim.cmd('autocmd QuickFixCmdPost *grep* cwindow')

-- "vimの矩形選択で文字が無くても右へ進める" を切り替える
vim.api.nvim_set_keymap('n', '<F2>', ':lua ToggleVirtualEdit()<CR>', { noremap = true })
vim.g.toggle_virtualedit = 0
function ToggleVirtualEdit()
    if vim.g.toggle_virtualedit == 0 then
        vim.g.toggle_virtualedit = 1
        vim.o.virtualedit = 'block'
        print('virtualedit=block')
    else
        vim.g.toggle_virtualedit = 0
        vim.o.virtualedit = 'none'
        print('virtualedit=none')
    end
end

-- 最後のカーソル位置を復元する
vim.cmd([[
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     exe "normal! g'\"" |
        \ endif
]])

vim.o.mouse = 'a'

if not vim.g.loaded_matchit then
    -- matchitを有効化
    vim.cmd('runtime macros/matchit.vim')
end

if vim.fn.has('vim') == 1 then
    -- 標準ファイラーは使わないからOFF
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrwSettings = 1
    vim.g.loaded_netrwFileHandlers = 1
end

-- ====== mapping ======
vim.cmd('set notimeout')
vim.cmd('set ttimeout')
vim.cmd('set timeoutlen=100')

vim.api.nvim_set_keymap('n', '<Esc>', ':noh<CR>', { silent = true })
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', { silent = true })
vim.api.nvim_set_keymap('i', '<C-e>', '<End>', { silent = true })
-- <C-o>: insert mode時に一時的にnormal modeへ移行するキー
vim.api.nvim_set_keymap('i', '<C-a>', '<C-o>:lua home()<CR>', { silent = true })
vim.api.nvim_set_keymap('i', '<C-d>', '<BackSpace>', { silent = true })
vim.api.nvim_set_keymap('i', '<C-h>', '<Left>', { silent = true })
vim.api.nvim_set_keymap('i', '<C-k>', '<Up>', { silent = true })
vim.api.nvim_set_keymap('i', '<C-j>', '<Down>', { silent = true })
-- vim.api.nvim_set_keymap('i', '<C-l>', '<Right>', { silent = true }) -- copilot.vim 側でremapする

function home()
  local start_column = vim.fn.col('.') -- 元のカラム番号を取得
  -- normal mode の ^ 相当の移動をする
  vim.cmd('normal! ^')
  -- 既に ^ 相当の移動後の位置にいる場合は 0 相当の移動をする
  if vim.fn.col('.') == start_column then
    vim.cmd('normal! 0')
  end
  return ''
end

-- === normal ===
-- vim.api.nvim_set_keymap('n', '<Esc>', ':noh<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 's', '<Nop>', { silent = true })
vim.api.nvim_set_keymap('n', 'p', 'p`]', { silent = true })
vim.cmd('nnoremap <silent> x "_x') -- nvim_set_keymap を使って競ってすると何故かフリーズするためcmdで設定
vim.api.nvim_set_keymap('n', '<Space>w', ':write<CR>', { silent = true })

-- vim.api.nvim_set_keymap('n', '<C-]>', 'g<C-]>', { silent = true })
vim.api.nvim_set_keymap('n', '}', ':cn<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '{', ':cN<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>c', '<ESC>:let @+ = expand("%:t")<CR>', { silent = true }) -- ファイル名
vim.api.nvim_set_keymap('n', '<Space>C', '<ESC>:let @+ = fnamemodify(expand("%"), ":~:.")<CR>', { silent = true }) -- ファイルパス
vim.api.nvim_set_keymap('n', '<C-C>',    '<ESC>:let @+ = fnamemodify(expand("%"), ":~:.") . ":" . line(".")<CR>', { silent = true }) -- ファイルパス:行番号
vim.api.nvim_set_keymap('n', 'J', 'V:m \'>+1<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 'K', 'V:m \'<-2<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 'E', '<ESC>:e!<CR>', { silent = true })

-- === buffer系 ===
-- 未保存の場合にバッファを切り替えても警告を出さない
vim.o.hidden = true

vim.o.showtabline = 2

-- === command系 ===
vim.cmd('command! SJIS edit ++enc=sjis')
vim.cmd('command! UTF8 edit ++enc=utf-8')

-- === window系 ===
vim.api.nvim_set_keymap('n', '<Space>e', '<C-w>w', {})

vim.api.nvim_set_keymap('n', '<Space>o', ':only<CR>', {})

-- === visual系 ===
-- ヤンクしたテキストの末尾へ自動的に移動
vim.api.nvim_set_keymap('v', 'y', 'y`]', { silent = true})
-- 貼り付けたたテキストの末尾へ自動的に移動 & 選択していた範囲の文字をレジスタに入れない
vim.api.nvim_set_keymap('v', 'p', 'P`]', { silent = true })
-- J, K で行を上下に移動する
vim.api.nvim_set_keymap('v', 'J', ':m \'>+1<CR>gv=gv', { silent = true })
vim.api.nvim_set_keymap('v', 'K', ':m \'<-2<CR>gv=gv', { silent = true })
-- Xで範囲を検索する(記号が入っていると上手く行かない場合がある)
vim.api.nvim_set_keymap('v', 'X', 'y/<C-R>"<CR>', { silent = true })

-- === command系 ===
vim.api.nvim_set_keymap('n', '<F5>', ':set wrap!<CR>', { noremap = true })

vim.api.nvim_set_keymap('c', '<C-e>', '<End>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-a>', '<Home>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-h>', '<Left>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-l>', '<Right>', { noremap = true })

-- == color ==
-- ターミナルでも True Color を使えるようにする
vim.cmd('set termguicolors')

vim.api.nvim_set_keymap('n', '<F3>', ':lua ToggleTransparent()<CR>', { noremap = true })
function ToggleTransparent()
  local bg = vim.api.nvim_get_hl_by_name('Normal', true).background
  if bg then -- 退避 & 透明化
    vim.g.saved_normal_guibg = bg
    vim.api.nvim_set_hl(0, 'Normal', { background = 'NONE' })
    print('background color disabled')
  else -- 復元
    vim.api.nvim_set_hl(0, 'Normal', { background = vim.g.saved_normal_guibg })
    print('background color enabled')
  end
end

-- floating windows を半透明に表示する
vim.o.winblend = 5
vim.cmd('highlight Visual      guibg=#006080 guifg=none')
vim.cmd('highlight Search      guibg=#00FFFF guifg=none')

-- == Util関数 ==
function GetFloatingWindows()
    local floating_windows = {}
    local all_windows = vim.api.nvim_list_wins()
    for _, win_id in ipairs(all_windows) do
        local config = vim.api.nvim_win_get_config(win_id)
        if config.relative ~= '' then -- relativeが空でないとき、それはfloating window
            table.insert(floating_windows, win_id)
        end
    end
    return floating_windows
end

-- :p vim.api.nvim_list_wins() のように使う
vim.cmd('cabbrev p PrettyPrintLuaExp')
vim.api.nvim_create_user_command('PrettyPrintLuaExp', function(opts)
    print(vim.inspect(opts.arg))
end, { nargs = 1 })
