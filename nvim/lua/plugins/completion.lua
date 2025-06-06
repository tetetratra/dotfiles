-- 補完 (CoC)
return {
  {
    'neoclide/coc.nvim',
    branch = 'release',
    build = function()
      vim.cmd('call coc#util#install()')
    end,
    config = function()
      local keyset = vim.keymap.set
      function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      keyset('i', '<TAB>', [[coc#pum#visible() ? coc#pum#next(1) : (v:lua.check_back_space() ? '<TAB>' : coc#refresh())]], opts)
      keyset('i', '<Down>', [[coc#pum#visible() ? coc#pum#next(1) : '<Down>']], opts)
      keyset('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : '\<C-h>']], opts)
      keyset('i', '<Up>', [[coc#pum#visible() ? coc#pum#prev(1) : '<Up>']], opts)
      keyset('i', '<cr>', [[coc#pum#visible() ? coc#pum#confirm() : '\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>']], opts)
      keyset('n', '<Space>[', '<Plug>(coc-references)', { silent = true })
      vim.api.nvim_set_keymap('n', '<C-]>', ':lua jump_gf_lsp_tag()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>lua show_documentation()<CR>', { noremap = true, silent = true })
      function show_documentation()
        vim.fn.CocAction('doHover')
      end
    end,
  },
}
