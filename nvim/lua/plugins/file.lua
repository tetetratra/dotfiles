-- ファイラー
return {
  {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup()
      local api = require("nvim-tree.api")


      local function preload_files_from_ls_ss()
        -- git ls-ss の出力（ファイルパスのリスト）を取得
        local handle = io.popen("git ls-ss")
        if not handle then return end

        for filepath in handle:lines() do
          -- 絶対パスに変換（Neovim APIは絶対パスでバッファ管理）
          local abs_path = vim.fn.fnamemodify(filepath, ":p")

          -- すでにバッファに載っていなければ badd で読み込む
          if vim.fn.bufnr(abs_path) == -1 then
            vim.cmd("silent! badd " .. vim.fn.fnameescape(abs_path))
          end
        end

        handle:close()
      end


      function open_nvim_tree_floating()
        if api.tree.is_visible() then
          api.tree.close()
          return
        end

        require("nvim-tree").setup({
          view = {
            float = {
              enable = true,
              open_win_config = function()
                local columns = vim.o.columns
                local lines = vim.o.lines
                local width = math.floor(columns * 0.6)
                local height = math.floor(lines * 0.8)
                return {
                  relative = "editor",
                  border = "rounded",
                  width = width,
                  height = height,
                  row = math.floor((lines - height) / 2),
                  col = math.floor((columns - width) / 2),
                }
              end,
            },
            adaptive_size = false,
          },
        })

        preload_files_from_ls_ss()

        api.tree.open()
        api.tree.toggle_no_buffer_filter()
        api.tree.expand_all()

        -- Escで閉じるための一時マップを作る
        local win_id = vim.api.nvim_get_current_win()
        vim.keymap.set("n", "<Esc>", function()
          api.tree.close()
        end, { buffer = 0, nowait = true, silent = true })
      end

      function open_nvim_tree_left()
        if api.tree.is_visible() then
          api.tree.close()
          return
        end

        require("nvim-tree").setup({
          view = {
            float = {
              enable = false,
            },
            side = "left",
            width = 30,
            adaptive_size = false,
          },
        })

        api.tree.open({ find_file = true, focus = true })
      end

      vim.keymap.set("n", ";",    open_nvim_tree_floating, { desc = "NvimTree: Floating" })
      vim.keymap.set("n", "<F2>", open_nvim_tree_left, { desc = "NvimTree: Normal Left" })



    end,
  },
  { 'ryanoasis/vim-devicons' },
  { 'bogado/file-line' },
}
