-- lua/plugins/telescope.lua
return {
  -----------------------------------------------------------------------------
  -- Telescope 本体 -----------------------------------------------------------
  -----------------------------------------------------------------------------
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
      local telescope = require('telescope')
      local sorters   = require('telescope.sorters')

      ------------------------------------------------------------------------
      -- 1. 空白トークン AND マッチ用ソータ（Lua だけ）
      ------------------------------------------------------------------------
      local function token_sorter(_opts)
        return sorters.Sorter:new{
          scoring_function = function(_, prompt, line)
            if not prompt or prompt == '' then
              return 1                           -- 空入力は常にヒット
            end
            local pos = 1
            for tok in prompt:lower():gmatch('%S+') do
              local s, e = line:lower():find(tok, pos, true)
              if not s then return -1 end        -- 1 トークンでも無ければ不一致
              pos = e + 1
            end
            return 0
          end,
        }
      end

      ------------------------------------------------------------------------
      -- 2. Telescope 設定
      ------------------------------------------------------------------------
      telescope.setup{
        defaults = {
          file_sorter    = token_sorter,         -- find_files 用
          generic_sorter = token_sorter,         -- 他ピッカーにも適用

          mappings = {
            n = {
              ['<esc>'] = require('telescope.actions').close,
              ['<C-d>'] = require('telescope.actions').close,
              ['q']     = require('telescope.actions').close,
            },
            i = {
              ['<esc>']  = require('telescope.actions').close,
              ['<Down>'] = require('telescope.actions').cycle_history_next,
              ['<Up>']   = require('telescope.actions').cycle_history_prev,
            },
          },
          preview = { treesitter = { enable = false } },
        },
      }

      ------------------------------------------------------------------------
      -- 3. キーマッピング
      ------------------------------------------------------------------------
      local builtin = require('telescope.builtin')

      vim.keymap.set('n', '<Space>f', function()
        builtin.find_files({ initial_mode = 'normal' })
      end, { noremap = true })

      vim.keymap.set('n', '<Space>?', function()
        builtin.help_tags({ initial_mode = 'normal' })
      end, { noremap = true })

      vim.keymap.set('n', '<Space>r', function()
        builtin.resume({ initial_mode = 'normal' })
      end, { noremap = true })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'TelescopeResults',
        command = [[setlocal nofoldenable]],
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- live_grep_args 拡張 -------------------------------------------------------
  -----------------------------------------------------------------------------
  {
    'nvim-telescope/telescope-live-grep-args.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },

    config = function()
      local telescope = require('telescope')
      telescope.load_extension('live_grep_args')
      local lga = telescope.extensions.live_grep_args

      vim.keymap.set('n', '<Space>g', function()
        lga.live_grep_args({
          initial_mode  = 'normal',
          auto_quoting  = false,          -- 引数の自動クォートを無効化
          -- auto_quoting  = true,
          additional_args = function(opts)
            local q = opts.prompt or ''
            if q == '' then return { '--hidden', '--glob', '!.git/**' } end
            return {
              '--hidden',               -- 隠しファイルも検索
              '--glob', '!.git/**',     -- .git 以下だけ除外
              '--pcre2',                -- 正規表現モード
              -- '-e', q:gsub('%s+', '.*'), -- 空白を .* に変換
            }
          end,
          --------------------------------------------------------------------
          -- ★ 入力が変わる度に空白 → ".*" へリアルタイム変換
          --------------------------------------------------------------------
          on_input_filter_cb = function(prompt)
            -- Telescope へ表示する文言はそのまま、実際に渡すパターンだけ変換
            if not prompt then return { prompt = prompt } end
            local rg_pat = prompt:gsub('%s+', '.*')
            return {
              prompt = rg_pat,        -- ripgrep に渡す検索語
              updated_prompt = prompt -- 画面に見えるプロンプト
            }
          end,
        })
      end, { noremap = true })
    end,
  },
}
