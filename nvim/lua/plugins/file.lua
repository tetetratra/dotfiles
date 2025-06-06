-- ファイラー
return {
  {
    'kyazdani42/nvim-tree.lua',
    config = function()
      vim.g.nvim_tree_highlight_opened_files = 1
      require('nvim-tree').setup({
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        renderer = {
          highlight_opened_files = 'all',
        },
        view = {
          width = 50,
        },
      })
      vim.api.nvim_set_keymap('n', '<F2>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    end,
  },
  { 'ryanoasis/vim-devicons' },
  { 'Xuyuanp/nerdtree-git-plugin' },
  { 'bogado/file-line' },
}
