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
    'inkarkat/vim-mark',
    dependencies = { 'inkarkat/vim-ingo-library' },
    init = function()
      -- デフォルトのキーバインド(*, #, <Leader>m等)を無効化する
      vim.g.mw_no_mappings = 1
      -- ハイライトの優先度を上げて、カーソル行(cursorline)よりも前面に表示されるようにする
      vim.g.mwMaxMatchPriority = 10
      -- カーソル位置に関わらず常にハイライトを表示する
      vim.g.mwExclCursor = 0
    end,
    config = function()
      local pattern = ('binding.pry,binding.irb,NOTE:,MEMO:,<<<<<<<,>>>>>>>,======='):gsub(',', '\\|')
      vim.api.nvim_set_keymap('n', '<Space>h', '<Plug>MarkSet', { silent = true })
      vim.api.nvim_set_keymap('x', '<Space>h', '<Plug>MarkSet', { silent = true })
      vim.api.nvim_set_keymap('n', '<Space>H', '<Plug>MarkAllClear', { silent = true })
      -- 起動時にデフォルトのパターンをハイライト
      vim.cmd('Mark /' .. pattern .. '/')
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
