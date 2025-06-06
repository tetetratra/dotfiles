-- 操作
return {
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
      vim.api.nvim_set_keymap('v', '<C-c>', '<Plug>(comment_toggle_linewise_visual)', { noremap = true, silent = true })
    end,
  },
  { 'tpope/vim-surround' },
  { 'vim-scripts/Align' },
  {
    'kana/vim-operator-replace',
    dependencies = { 'kana/vim-operator-user' },
    config = function()
      vim.api.nvim_set_keymap('n', 'R', '<Plug>(operator-replace)', {})
    end,
  },
  {
    'tyru/operator-camelize.vim',
    dependencies = { 'kana/vim-operator-user' },
    config = function()
      vim.api.nvim_set_keymap('v', '<Space>s', '<Plug>(operator-camelize-toggle)', {})
    end,
  },
  {
    'j-morano/buffer_manager.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('buffer_manager').setup({
        width = 100,
        height = 30,
        select_menu_item_commands = {
          v = { key = '<C-v>', command = 'vsplit' },
          h = { key = '<C-h>', command = 'split' },
        },
      })
      vim.api.nvim_set_keymap('n', ';', ':lua require("buffer_manager.ui").toggle_quick_menu()<CR>', { noremap = true })
    end,
  },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'iceberg_dark',
          component_separators = '',
          section_separators = '',
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {},
      })
    end,
  },
  {
    'simeji/winresizer',
    config = function()
      vim.cmd([[
    let g:winresizer_vert_resize = 5
    let g:winresizer_start_key = '<F1>'
    ]])
    end,
  },
  {
    'osyo-manga/vim-brightest',
    config = function()
      vim.cmd([[
    let g:brightest#highlight = { "group" : "BrightestUnderline" }
    let g:brightest#pattern = '\\k\\+'
    ]])
    end,
  },
  { 'nvim-treesitter/nvim-treesitter', build = 'TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-context', dependencies = { 'nvim-treesitter' } },
  {
    'm-demare/hlargs.nvim',
    dependencies = { 'nvim-treesitter' },
    config = function()
      require('hlargs').setup({ color = '#C0D0FF' })
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    dependencies = { 'nvim-treesitter' },
    config = function()
      local highlight = { 'CursorColumn', 'Whitespace' }
      require('ibl').setup({
        indent = { highlight = highlight, char = '' },
        whitespace = { highlight = highlight, remove_blankline_trail = false },
        scope = { enabled = false },
      })
    end,
  },
  {
    'cohama/lexima.vim',
    config = function()
      vim.cmd([[
    " スペースを入れてくれる補完はめったに使わないので無効化
    let g:lexima_enable_space_rules = 0
    ]])
    end,
  },
  {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.cmd([[
    let g:better_whitespace_guicolor = 'DarkRed'
    ]])
    end,
  },
}
