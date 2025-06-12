-- mark
return {
  {
    'kshenoy/vim-signature',
    config = function()
      vim.g.SignatureMap = { ToggleMarkAtLine = '<Space>m' }
      vim.g.SignatureIncludeMarks = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      vim.api.nvim_set_keymap('n', '<Space>M', ':delmarks A-Z<CR>', { silent = true })
    end,
  },
  {
    't9md/vim-quickhl',
    config = function()
      local pattern = ('binding.pry,binding.irb,NOTE:,MEMO:,<<<<<<<,>>>>>>>,======='):gsub(',', '\\|')
      vim.api.nvim_set_keymap('n', '<Space>h', '<Plug>(quickhl-manual-this-whole-word)', { silent = true })
      vim.api.nvim_set_keymap('x', '<Space>h', '<Plug>(quickhl-manual-this)', { silent = true })
      vim.api.nvim_set_keymap('n', '<Space>H', '<Plug>(quickhl-manual-reset)', { silent = true })
      vim.g.quickhl_manual_enable_at_startup = 1
      vim.g.quickhl_manual_keywords = { { pattern = pattern, regexp = 1 } }
      vim.cmd("call quickhl#manual#enable()") -- 起動時にマークが効かないことがあるため強制的に有効化
    end,
  },
  {
    'kristijanhusak/line-notes.nvim',
    config = function()
      local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')
      require('line-notes').setup({
        path = git_root .. '/line-notes.json',
        border_style = 'none',
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        callback = function()
          require('line-notes').preview()
        end,
      })
      vim.api.nvim_set_keymap('n', '<Space>n', ':lua require("line-notes").add()<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<Space>N', ':lua require("line-notes").delete()<CR>', { noremap = true })
    end,
  },
}
