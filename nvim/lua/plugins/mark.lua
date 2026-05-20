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
      -- 色数を増やすため、優先度を大幅に上げます (色数以上の値が必要)
      vim.g.mwMaxMatchPriority = 200

      -- 【色の拡張設定】
      -- デフォルトでは6色のみですが、利便性向上のため120色のカラーパレットを自動生成しています。
      -- 256色パレットの鮮やかな領域(17-231番)から色をピックアップし、GUI環境(TrueColor)でも
      -- 同様の色味が再現されるようにRGB値を計算して割り当てています。
      
      -- 【優先度の調整】
      -- vim-markの内部仕様として、1色あたりの優先度は「mwMaxMatchPriority - 全色数 + 1 + 色番号」
      -- で計算されます。色数を増やすとこの値が小さくなり、カーソル行(cursorline: 優先度-1)の背面に
      -- 隠れて色が消えてしまうため、全色数を考慮して十分な優先度(200)を確保しています。
      local palette = {}
      for i = 1, 120 do
        table.insert(palette, {
          -- 17〜231番の色（256色パレットの鮮やかな領域）を使用
          ctermbg = 16 + math.floor((i - 1) * (215 / 120)),
          ctermfg = "Black",
          -- GUI環境でも見えるように色を計算で生成
          guibg = string.format("#%02x%02x%02x", (i * 123) % 256, (i * 456) % 256, (i * 789) % 256),
          guifg = "Black"
        })
      end
      vim.g.mwDefaultHighlightingPalette = palette
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
