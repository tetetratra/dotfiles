local keymap = function(key, definition)
  vim.api.nvim_set_keymap('n', key, definition, { noremap = true, silent = true })
end


local keymap_i = function(key, definition)
  vim.api.nvim_set_keymap('i', key, definition, { noremap = true, silent = true })
end

local keymap_v = function(key, definition)
  vim.api.nvim_set_keymap('v', key, definition, { noremap = true, silent = true })
end

local keymap_c = function(key, definition)
  vim.api.nvim_set_keymap('c', key, definition, { noremap = true, silent = true })
end

-- "vimの矩形選択で文字が無くても右へ進める" を切り替える
keymap('<Esc>', ':noh<CR>')
keymap('T', ':lua write_last_messages_to_new_buffer()<CR>')
keymap('t', ':tabnew<CR>')
keymap('p', 'p`]')
keymap('x', '"_x') -- レジスタに入れない
keymap('<Space>w', ':write<CR>')
keymap('}', ':cn<CR>')
keymap('{', ':cN<CR>')
keymap('<Space>c', ':let @+ = expand("%:t")<CR>') -- ファイル名
keymap('<Space>C', ':let @+ = fnamemodify(expand("%"), ":~:.")<CR>') -- ファイルパス
keymap('<Space>;', ':let @+ = fnamemodify(expand("%"), ":~:.") . ":" . line(".")<CR>', { silent = true }) -- ファイルパス:行番号
keymap('<Space>:', ':lua get_github_url()<CR>')
keymap('J', 'V:m \'>+1<CR>')
keymap('K', 'V:m \'<-2<CR>')
keymap('E', '<ESC>:e!<CR>')
keymap('<C-l>', '<C-w>l')
keymap('<C-h>', '<C-w>h')
keymap('L', ':tabnext<CR>')
keymap('H', ':tabprevious<CR>')
keymap('>', ':+tabmove<CR>')
keymap('<', ':-tabmove<CR>')
keymap('<Space>q', '<C-w>c')
keymap('<Space>Q', ':bdelete<CR>')
keymap('<Space>e', '<C-w>w')
keymap('<Space>o', ':only<CR>')
keymap('<Space><F2>', ':lua ToggleVirtualEdit()<CR>')
keymap('<Space><F3>', ':lua ToggleTransparent()<CR>')
keymap('<Space><F5>', ':set wrap!<CR>')

keymap_i('jj', '<ESC>')
keymap_i('<C-e>', '<End>')
keymap_i('<C-a>', '<C-o>:lua home()<CR>')
keymap_i('<C-d>', '<BackSpace>')
keymap_i('<C-h>', '<Left>')
keymap_i('<C-k>', '<Up>')
keymap_i('<C-j>', '<Down>')
-- <C-l>はcopilot.vim 側でremapする

-- ヤンクしたテキストの末尾へ自動的に移動
keymap_v('y', 'y`]')
-- 貼り付けたたテキストの末尾へ自動的に移動 & 選択していた範囲の文字をレジスタに入れない
keymap_v('p', 'P`]')
-- J, K で行を上下に移動する
keymap_v('J', ':m \'>+1<CR>gv=gv')
keymap_v('K', ':m \'<-2<CR>gv=gv')
-- Xで範囲を検索する(記号が入っていると上手く行かない場合がある)
keymap_v('X', 'y/<C-R>"<CR>')

keymap_c('<C-e>', '<End>')
keymap_c('<C-a>', '<Home>')
keymap_c('<C-h>', '<Left>')
keymap_c('<C-l>', '<Right>')

