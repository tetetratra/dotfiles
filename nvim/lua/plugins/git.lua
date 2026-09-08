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
  {
    'sindrets/diffview.nvim',
    config = function()
      local function run(command)
        local result = vim.system(command, { text = true }):wait()
        assert(result.code == 0, result.stderr)
        return vim.trim(result.stdout or '')
      end

      -- 使い方: `:R ブランチ名`
      -- 指定ブランチへ切り替え、PRのbase（PRがなければデフォルトブランチ）との差分を開く
      -- 右側でLSPを利用できるよう、比較対象をHEADにしてDiffviewOpenへ--imply-localを渡している
      vim.api.nvim_create_user_command('R', function(opts)
        local branch = opts.args

        -- 最新のリモートブランチを取得して、指定ブランチへ切り替える
        run({ 'git', 'fetch', 'origin' })
        run({ 'git', 'switch', branch })
        vim.cmd('checktime')

        -- 最初のopen PRから比較元のブランチを取得する
        local base_branch = run({
          'gh', 'pr', 'list',
          '--head', branch,
          '--state', 'open',
          '--limit', '1',
          '--json', 'baseRefName',
          '--jq', '.[0].baseRefName // empty',
        })

        -- PRがない場合はデフォルトブランチを比較元にする
        if base_branch == '' then
          base_branch = run({
            'gh', 'repo', 'view',
            '--json', 'defaultBranchRef',
            '--jq', '.defaultBranchRef.name',
          })
        end

        -- PR相当の範囲を、LSPを利用できるローカルファイルとして開く
        vim.api.nvim_cmd({
          cmd = 'DiffviewOpen',
          args = { 'origin/' .. base_branch .. '...HEAD', '--imply-local' },
        }, {})
      end, {
        nargs = 1,
        desc = '指定したブランチへ切り替え、PRのbaseとの差分を開く',
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
