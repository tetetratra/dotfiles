local n = function(key, definition)
  vim.api.nvim_set_keymap('n', key, definition, { noremap = true, silent = true })
end

local i = function(key, definition)
  vim.api.nvim_set_keymap('i', key, definition, { noremap = true, silent = true })
end

local v = function(key, definition)
  vim.api.nvim_set_keymap('v', key, definition, { noremap = true, silent = true })
end

local c = function(key, definition)
  vim.api.nvim_set_keymap('c', key, definition, { noremap = true, silent = true })
end

n('<Esc>', ':noh<CR>')
n('T', ':lua write_last_messages_to_new_buffer()<CR>')
n('t', ':tabnew<CR>')
-- タブを複製
n('yt', ':lua tab_clone_with_cursor()<CR>')
n('p', 'p`]')
n('x', '"_x') -- レジスタに入れない
n('}', ':cn<CR>')
n('{', ':cN<CR>')
n('J', 'V:m \'>+1<CR>')
n('K', 'V:m \'<-2<CR>')
n('E', ':e!<CR>')
n('<C-l>', '<C-w>l')
n('<C-h>', '<C-w>h')
n('L', ':tabnext<CR>')
n('H', ':tabprevious<CR>')
n('>', ':+tabmove<CR>')
n('<', ':-tabmove<CR>')
n('<Space>c', ':let @+ = expand("%:t")<CR>') -- ファイル名
n('<Space>C', ':let @+ = fnamemodify(expand("%"), ":~:.")<CR>') -- ファイルパス
n('<Space>;', ':let @+ = fnamemodify(expand("%"), ":~:.") . ":" . line(".")<CR>', { silent = true }) -- ファイルパス:行番号
n('<Space>:', ':lua get_github_url()<CR>')
n('<Space>w', ':write<CR>')
n('<Space>q', '<C-w>c')
n('<Space>Q', ':bdelete<CR>')
n('<Space>e', '<C-w>w')
n('<Space>o', ':only<CR>')
n('<Space>t', '<C-w>T') -- 現在のwindowをtabで開く
n('<Space><F2>', ':lua toggle_virtual_edit()<CR>') -- "vimの矩形選択で文字が無くても右へ進める" を切り替える
n('<Space><F3>', ':lua toggle_transparent()<CR>')
n('<Space><F5>', ':set wrap!<CR>')

i('jj', '<ESC>')
i('<C-e>', '<End>')
i('<C-a>', '<C-o>:lua home()<CR>')
i('<C-d>', '<BackSpace>')
i('<C-j>', '<Down>') -- <C-l>はcopilot.vim 側でremapする

v('y', 'y`]') -- ヤンクしたテキストの末尾へ自動的に移動
v('p', 'P`]') -- 貼り付けたたテキストの末尾へ自動的に移動 & 選択していた範囲の文字をレジスタに入れない
v('J', ':m \'>+1<CR>gv=gv') -- J, K で行を上下に移動する
v('K', ':m \'<-2<CR>gv=gv') -- J, K で行を上下に移動する
v('X', 'y/<C-R>"<CR>') -- Xで範囲を検索する(記号が入っていると上手く行かない場合がある)

c('<C-e>', '<End>')
c('<C-a>', '<Home>')
c('<C-h>', '<Left>')
c('<C-l>', '<Right>')
