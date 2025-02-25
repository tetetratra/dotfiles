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
-- 未保存の場合にバッファを切り替えても警告を出さない
vim.o.hidden = true
-- 最後のカーソル位置を復元する
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local line = vim.fn.line
        if line("'\"") > 0 and line("'\"") <= line("$") then
            vim.cmd("normal! g'\"")
        end
    end,
})
-- マウスを有効にする
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

vim.cmd('set notimeout')
vim.cmd('set ttimeout')
vim.cmd('set timeoutlen=100')

-- タブラインを常に表示する
vim.o.showtabline = 2

-- === command系 ===
vim.cmd('command! SJIS edit ++enc=sjis')
vim.cmd('command! UTF8 edit ++enc=utf-8')

-- ターミナルでも True Color を使えるようにする
vim.cmd('set termguicolors')

-- floating windows を半透明に表示する
vim.o.winblend = 5
vim.cmd('highlight Visual      guibg=#006080 guifg=none')
vim.cmd('highlight Search      guibg=#00FFFF guifg=none')

-- :p vim.api.nvim_list_wins() のように使う
vim.cmd('cabbrev p PrettyPrintLuaExp')
vim.api.nvim_create_user_command('PrettyPrintLuaExp', function(opts)
  print(vim.inspect(opts.arg))
end, { nargs = 1 })
