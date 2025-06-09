-- fuzzy finder
return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      vim.api.nvim_set_keymap('n', '<Space>f', ':lua require("telescope.builtin").find_files({ initial_mode = "normal" })<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<Space>?', ':lua require("telescope.builtin").help_tags({ initial_mode = "normal" })<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<Space>r', ':lua require("telescope.builtin").resume({ initial_mode = "normal" })<cr>', { noremap = true })
      vim.api.nvim_create_autocmd('FileType', { pattern = 'TelescopeResults', command = [[setlocal nofoldenable]] })
      require('telescope').setup({
        defaults = {
          mappings = {
            n = {
              ['<esc>'] = require('telescope.actions').close,
              ['<C-d>'] = require('telescope.actions').close,
              ['q'] = require('telescope.actions').close,
            },
            i = {
              ['<esc>'] = require('telescope.actions').close,
              ['<Down>'] = require('telescope.actions').cycle_history_next,
              ['<Up>'] = require('telescope.actions').cycle_history_prev,
            },
          },
          preview = {
            treesitter = { enable = false },
          },
        },
      })
    end,
  },
  {
    'nvim-telescope/telescope-live-grep-args.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('live_grep_args')
      vim.api.nvim_set_keymap('n', '<Space>g', ':lua require("telescope").extensions.live_grep_args.live_grep_args({ initial_mode = "normal" })<cr>', { noremap = true })
    end,
  },
}
