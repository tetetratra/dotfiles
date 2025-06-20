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
}
