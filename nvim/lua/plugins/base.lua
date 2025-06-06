-- 基本プラグイン
return {
  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({})
    end,
  },
  {
    'karb94/neoscroll.nvim',
    config = function()
      neoscroll = require('neoscroll')
      vim.keymap.set({ 'n', 'v', 'x' }, '<C-u>', function()
        neoscroll.ctrl_u({ duration = 100 })
      end)
      vim.keymap.set({ 'n', 'v', 'x' }, '<C-d>', function()
        neoscroll.ctrl_d({ duration = 100 })
      end)
      neoscroll.setup({})
    end,
  },
  { 'nvim-lua/plenary.nvim' },
}
