return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          -- fzf の拡張検索ロジックを有効にするための最低限設定
          file_ignore_patterns = { "node_modules", ".git/" },

          -- 起動時はノーマルモード開始
          initial_mode = "normal",

          -- smart_case により大文字小文字無視
          -- fuzzy により snake/camel 無視 & subsequence マッチ
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          -- Telescope 起動中に上下キーで入力履歴をたどれるようにする
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
        pickers = {
          find_files = {
            previewer = false,
          },
          live_grep = {
            previewer = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- subsequence マッチ（hoge fuga → hogeisfuga）
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      telescope.load_extension("fzf")

      -- キーマッピング
      vim.keymap.set("n", "<Space>f", function()
        require("telescope.builtin").find_files({ hidden = true }) -- 隠しファイルも表示
      end, { silent = true })

      vim.keymap.set("n", "<Space>F", function() -- ディレクトリ指定して find_files
        local dir = vim.fn.input("Find files in dir: ", "", "dir")
        require("telescope.builtin").find_files({
          cwd = dir ~= "" and dir or nil,
          hidden = true
        })
      end, { silent = true })

      vim.keymap.set("n", "<Space>g", function()
        require("telescope.builtin").live_grep({
          additional_args = function(_)
            return { "--hidden", "--glob", "!.git/*" } -- hidden を含めるが、.git 配下は除外
          end,
        })
      end, { silent = true })

      vim.keymap.set("n", "<Space>G", function() -- ディレクトリ指定して live_grep
        local dir = vim.fn.input("Grep in dir: ", "", "dir")
        require("telescope.builtin").live_grep({
          cwd = dir ~= "" and dir or nil,
          additional_args = function(_)
            return { "--hidden", "--glob", "!.git/*" } -- hidden を含めるが、.git 配下は除外
          end,
        })
      end, { silent = true })

      vim.keymap.set("n", "<Space>r", builtin.resume, { silent = true }) -- 直近の検索を再開
    end,
  }
}
