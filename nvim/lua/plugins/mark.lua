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
      -- デフォルトでは6色のみですが、利便性向上のためカラーパレットを自動生成しています。
      -- 256色パレットの6x6x6カラーキューブ(16-231番)を候補とし、GUI環境(TrueColor)でも
      -- 同じ色味になるよう、各番号に対応するRGB値をguibgに割り当てています。

      -- 【暗い色の除外】
      -- 文字色は黒固定のため、背景が暗いと文字が読めなくなります。
      -- 相対輝度が0.3未満(黒文字とのコントラスト比が7:1未満)の色は除外しています。

      -- 【優先度の調整】
      -- vim-markの内部仕様として、1色あたりの優先度は「mwMaxMatchPriority - 全色数 + 1 + 色番号」
      -- で計算されます。色数を増やすとこの値が小さくなり、カーソル行(cursorline: 優先度-1)の背面に
      -- 隠れて色が消えてしまうため、全色数を考慮して十分な優先度(200)を確保しています。
      local levels = { 0, 95, 135, 175, 215, 255 }
      local function linear(c)
        c = c / 255
        return c <= 0.03928 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
      end
      local candidates = {}
      for n = 16, 231 do
        local k = n - 16
        local r, g, b = levels[math.floor(k / 36) + 1], levels[math.floor(k / 6) % 6 + 1], levels[k % 6 + 1]
        local luminance = 0.2126 * linear(r) + 0.7152 * linear(g) + 0.0722 * linear(b)
        if luminance >= 0.3 then
          table.insert(candidates, { ctermbg = n, guibg = string.format('#%02x%02x%02x', r, g, b) })
        end
      end

      -- 番号順のままだと連続して付けたマークが似た色になるため、
      -- 候補数と互いに素な間隔で飛ばしながら並べ替えています。
      local function gcd(a, b) return b == 0 and a or gcd(b, a % b) end
      local stride = 37
      while gcd(#candidates, stride) ~= 1 do stride = stride + 1 end
      local palette = {}
      for i = 0, #candidates - 1 do
        local c = candidates[(i * stride) % #candidates + 1]
        table.insert(palette, { ctermbg = c.ctermbg, ctermfg = 'Black', guibg = c.guibg, guifg = 'Black' })
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
