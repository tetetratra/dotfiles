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
