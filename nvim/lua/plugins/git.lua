-- git
return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.cmd('cabbrev g Ggrep')
      vim.cmd('cabbrev l Git log --follow -p %')
    end,
  },
  { 'tpope/vim-rhubarb' },
  { 'sindrets/diffview.nvim' },
  -- 未addの変更はgitgutter、デフォルトブランチ（developやmain）との差分はgitsignsで表示する
  -- コミット済みの行でも、PRに入る変更かどうかをサインカラムで見分けるため
  -- gitsignsもgitgutterも比較対象はバッファごとに1つしか持てないため、2つを併用している
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local gitsigns = require('gitsigns')
      local git_base = require('git_base')

      -- gitgutterの記号と並べて表示できるよう、サインカラムを2列にする
      vim.opt.signcolumn = 'yes:2'

      -- gitgutterの + ~ - と区別できるよう、記号と色を変える
      local function set_highlights()
        vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#5f87d7' })
        vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#af87d7' })
        vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#d75f87' })
      end
      set_highlights()
      vim.api.nvim_create_autocmd('ColorScheme', { callback = set_highlights })

      -- バッファの比較対象を、そのリポジトリのデフォルトブランチとの分岐点にする
      -- ブランチを切り替えると分岐点も変わるため、バッファに入るたびに計算し直し、変わったときだけ反映する
      local function update_base(bufnr)
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        -- gitsignsが最初の差分計算を終えるまでは、change_baseが何もせずに終わるため待つ
        -- （差分の件数が入っていれば計算済み）
        local status = vim.b[bufnr].gitsigns_status_dict
        if not status or status.added == nil then
          return
        end
        local base = git_base.get(bufnr)
        local merge_base = base and base.merge_base or nil
        if vim.b[bufnr].gitsigns_pr_base == merge_base then
          return
        end
        vim.b[bufnr].gitsigns_pr_base = merge_base
        -- change_baseは現在のバッファを対象にするため、対象バッファを現在のバッファにして呼ぶ
        vim.api.nvim_buf_call(bufnr, function()
          gitsigns.change_base(merge_base)
        end)
      end

      gitsigns.setup({
        signs = {
          add          = { text = '▎' },
          change       = { text = '▎' },
          delete       = { text = '▁' },
          topdelete    = { text = '▔' },
          changedelete = { text = '▎' },
          untracked    = { text = '▎' },
        },
        -- stageした変更の表示はgitgutterに任せる
        signs_staged_enable = false,
        -- 同じ行のサインは優先度の高い順に左から並ぶため、gitgutter（既定10）より高くして左に置く
        -- 線（▎）が左端にそろい、+ ~ - がその右に出るほうが見やすいため
        sign_priority = 11,
        -- `:e` などでアタッチし直すと比較対象がindexに戻るため、反映済みの記録を消して反映し直させる
        -- （バッファ変数は `:e` でも残るため、消さないと反映済みと判断されてしまう）
        on_attach = function(bufnr)
          vim.b[bufnr].gitsigns_pr_base = nil
        end,
      })

      -- 開いた直後は、gitsignsが差分を計算し終えたときに比較対象を変える
      vim.api.nvim_create_autocmd('User', {
        pattern = 'GitSignsUpdate',
        callback = function(ev)
          -- カレントディレクトリのブランチが変わったときなど、バッファ番号を持たない通知もあるため除く
          if ev.data and ev.data.buffer then
            update_base(ev.data.buffer)
          end
        end,
      })

      vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained' }, {
        callback = function(ev)
          update_base(ev.buf)
        end,
      })
    end,
  },
  {
    'airblade/vim-gitgutter',
    config = function()
      vim.cmd([[
        let g:gitgutter_git_executable = substitute(system('which git'), '\n\+$', '', '')
      ]])
    end,
  },
  {
    'rhysd/conflict-marker.vim',
    config = function()
      vim.g.conflict_marker_enable_mappings = 0
    end,
  },
  -- 使い方例:
  -- :Octo https://github.com/owner/repo/issues/123
  -- :e octo://owner/repo/issue/123
  -- :Octo pr list
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require("octo").setup()
    end,
  },
}
