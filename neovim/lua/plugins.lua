-- TODO:
-- - dein.tomlをluaファイル化(インデントも揃える)
-- - 各tab内にどんなwindowがあるかをサイドバーに表示できるようにする
-- - terraformのlspを入れる

return {
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  },
  {
    "karb94/neoscroll.nvim",
    config = function()
      neoscroll = require("neoscroll")
      vim.keymap.set({ "n", "v", "x" }, "<C-u>", function()
        neoscroll.ctrl_u({ duration = 100 })
      end)
      vim.keymap.set({ "n", "v", "x" }, "<C-d>", function()
        neoscroll.ctrl_d({ duration = 100 })
      end)
      neoscroll.setup({})
    end,
  },
  { "nvim-lua/plenary.nvim" },
  {
    "cocopon/iceberg.vim",
    config = function()
      vim.cmd("colorscheme iceberg")
      vim.cmd("highlight FloatBorder guibg=#242940 guifg=#242940 ctermbg=none")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "natecraddock/telescope-zf-native.nvim" },
    config = function()
      -- live_grep は ripgrep に依存している
      vim.api.nvim_set_keymap(
        "n",
        "<Space>f",
        ':lua require("telescope.builtin").find_files({ initial_mode = "normal" })<cr>',
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<Space>?",
        ':lua require("telescope.builtin").help_tags({ initial_mode = "normal" })<cr>',
        { noremap = true }
      ) -- helpを絞り込んで探せる(helpの連想で?のキー)
      -- vim.api.nvim_set_keymap('n', '<Space>b', ':lua require("telescope.builtin").buffers({ initial_mode = "normal" })<cr>', { noremap = true })
      vim.api.nvim_set_keymap(
        "n",
        "<Space>r",
        ':lua require("telescope.builtin").resume({ initial_mode = "normal" })<cr>',
        { noremap = true }
      )

      -- 折りたたみを無効化する 参考: https://github.com/nvim-telescope/telescope.nvim/issues/991#issuecomment-1429539473
      vim.api.nvim_create_autocmd("FileType", { pattern = "TelescopeResults", command = [[setlocal nofoldenable]] })

      -- 参考: https://dev.classmethod.jp/articles/nvim_telescope
      require("telescope").setup({
        defaults = {
          mappings = {
            n = {
              ["<esc>"] = require("telescope.actions").close,
              ["<C-d>"] = require("telescope.actions").close,
              ["q"] = require("telescope.actions").close,
            },
            i = {
              ["<esc>"] = require("telescope.actions").close,
              ["<Down>"] = require("telescope.actions").cycle_history_next,
              ["<Up>"] = require("telescope.actions").cycle_history_prev,
            },
          },
          preview = {
            treesitter = { enable = false }, -- 右側に表示されるプレビューまわりでtreesitterのエラーが起きるのでtelescope内では無効化する
          },
        },
        ["zf-native"] = {
          -- options for sorting file-like items
          file = {
            -- override default telescope file sorter
            enable = true,
            -- highlight matching text in results
            highlight_results = true,
            -- enable zf filename match priority
            match_filename = false,
          },

          -- options for sorting all other items
          generic = {
            -- override default telescope generic item sorter
            enable = true,
            -- highlight matching text in results
            highlight_results = true,
            -- disable zf filename match priority
            match_filename = false,
          },
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("live_grep_args")
      vim.api.nvim_set_keymap(
        "n",
        "<Space>g",
        ':lua require("telescope").extensions.live_grep_args.live_grep_args({ initial_mode = "normal" })<cr>',
        { noremap = true }
      ) -- grepのg
    end,
  },
  {
    "natecraddock/telescope-zf-native.nvim",
    config = function()
      -- telescopeの方にも設定あり
      require("telescope").load_extension("zf-native")
    end,
  },
  {
    "kyazdani42/nvim-tree.lua",
    config = function()
      vim.g.nvim_tree_highlight_opened_files = 1

      require("nvim-tree").setup({
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        renderer = {
          highlight_opened_files = "all",
        },
        view = {
          width = 50,
        },
      })

      vim.api.nvim_set_keymap("n", "<F2>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
  },
  { "ryanoasis/vim-devicons" },
  { "Xuyuanp/nerdtree-git-plugin" },
  -- ファイラー
  -- B でバッファにあるのみ表示
  -- C でgit上で変更されたファイルのみ表示
  -- P で親ディレクトリに移動
  -- <C-v> で縦分割で開く
  -- <C-x> で横分割で開く
  -- <Tab> でプレビュー
  -- E でexpand all
  -- W でcollapse all
  -- r でrename
  -- <C-k> でファイル情報を表示
  { "bogado/file-line" },
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = function()
      vim.cmd("call coc#util#install()")
    end,
    config = function()
      -- 公式のREADMEを参考に設定

      local keyset = vim.keymap.set
      -- Autocomplete
      function _G.check_back_space()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
      end

      -- Use Tab for trigger completion with characters ahead and navigate
      -- NOTE: There's always a completion item selected by default, you may want to enable
      -- no select by setting `"suggest.noselect": true` in your configuration file
      -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
      -- other plugins before putting this into your config
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      keyset(
        "i",
        "<TAB>",
        [[coc#pum#visible() ? coc#pum#next(1) : (v:lua.check_back_space() ? "<TAB>" : coc#refresh())]],
        opts
      )
      keyset("i", "<Down>", [[coc#pum#visible() ? coc#pum#next(1) : "<Down>"]], opts)
      keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
      keyset("i", "<Up>", [[coc#pum#visible() ? coc#pum#prev(1) : "<Up>"]], opts)

      -- Make <CR> to accept selected completion item or notify coc.nvim to format
      -- <C-g>u breaks current undo, please make your own choice
      keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- GoTo code navigation
      keyset("n", "<Space>[", "<Plug>(coc-references)", { silent = true })

      vim.api.nvim_set_keymap("n", "<C-]>", ":lua jump_gf_lsp_tag()<CR>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua show_documentation()<CR>", { noremap = true, silent = true })
      function show_documentation()
        vim.fn.CocAction("doHover")
      end
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()

      vim.api.nvim_set_keymap("v", "<C-c>", "<Plug>(comment_toggle_linewise_visual)", { noremap = true, silent = true })
    end,
  },
  { "tpope/vim-surround" },
  { "vim-scripts/Align" },
  {
    "kana/vim-operator-replace",
    dependencies = { "kana/vim-operator-user" },
    config = function()
      vim.api.nvim_set_keymap("n", "R", "<Plug>(operator-replace)", {})
    end,
  },
  {
    "tyru/operator-camelize.vim",
    config = function()
      vim.api.nvim_set_keymap("v", "<Space>s", "<Plug>(operator-camelize-toggle)", {})
    end,
  },
  {
    "j-morano/buffer_manager.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("buffer_manager").setup({
        width = 100,
        height = 30,
        select_menu_item_commands = {
          v = {
            key = "<C-v>",
            command = "vsplit",
          },
          h = {
            key = "<C-h>",
            command = "split",
          },
        },
      })
      vim.api.nvim_set_keymap("n", ";", ':lua require("buffer_manager.ui").toggle_quick_menu()<CR>', { noremap = true })
    end,
  },
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "iceberg_dark",
          component_separators = "",
          section_separators = "",
        },
        -- 選択箇所をyankで置き換え
        -- CamelCase <=> snake_case
        sections = {
          -- 左側のセクションは空にする（vimのmode等を表示しない）
          lualine_a = {},
          lualine_b = {},
          -- 中央にカスタムコンポーネント（Gitルートからの相対パス）を表示
          -- lualine_c = { { git_relative_filepath, color = {} } },
          -- 右側のセクションは空にする
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        -- 非アクティブウィンドウでも active セクションと同じ内容を表示する設定
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          -- lualine_c = { { git_relative_filepath, color = {} } },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {},
      })
    end,
  },
  {
    "simeji/winresizer",
    config = function()
      vim.cmd([[
    let g:winresizer_vert_resize = 5
    let g:winresizer_start_key = '<F1>'
    ]])
    end,
  },
  {
    "osyo-manga/vim-brightest",
    config = function()
      vim.cmd([[
    let g:brightest#highlight = { "group" : "BrightestUnderline" }
    let g:brightest#pattern = '\\k\\+'
    ]])
    end,
  },
  { "nvim-treesitter/nvim-treesitter", build = "TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context", dependencies = { "nvim-treesitter" } },
  {
    "m-demare/hlargs.nvim",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("hlargs").setup({
        color = "#C0D0FF",
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = { "nvim-treesitter" },
    config = function()
      local highlight = {
        "CursorColumn",
        "Whitespace",
      }
      require("ibl").setup({
        indent = { highlight = highlight, char = "" },
        whitespace = {
          highlight = highlight,
          remove_blankline_trail = false,
        },
        scope = { enabled = false },
      })
    end,
  },
  {
    "cohama/lexima.vim",
    config = function()
      vim.cmd([[
    " スペースを入れてくれる補完はめったに使わないので無効化
    let g:lexima_enable_space_rules = 0
    ]])
    end,
  },
  {
    "ntpeters/vim-better-whitespace",
    config = function()
      vim.cmd([[
    let g:better_whitespace_guicolor = 'DarkRed'
    ]])
    end,
  },
  {
    "othree/eregex.vim",
    config = function()
      vim.cmd([[
    let g:eregex_default_enable = 0
    nnoremap ? :M/
    ]])
    end,
  },
  {
    "henrik/vim-indexed-search",
    config = function()
      vim.cmd([[
    let g:indexed_search_dont_move = 1 " 検索時に1個下に動かないようになる
    let g:indexed_search_numbered_only = 1 " 検索カウントを簡素な表示に
    let g:indexed_search_shortmess = 1 " 検索カウントを簡素な表示に
    ]])
    end,
  },
  {
    "kshenoy/vim-signature",
    config = function()
      vim.g.SignatureMap = { ToggleMarkAtLine = "<Space>m" }
      vim.g.SignatureIncludeMarks = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      vim.api.nvim_set_keymap("n", "<Space>M", ":delmarks A-Z<CR>", { silent = true })
    end,
  },
  {
    "t9md/vim-quickhl",
    config = function()
      local pattern = ("binding.pry,binding.irb,NOTE:,MEMO:,<<<<<<<,>>>>>>>,======="):gsub(",", "\\|")
      vim.api.nvim_set_keymap("n", "<Space>h", "<Plug>(quickhl-manual-this-whole-word)", { silent = true })
      vim.api.nvim_set_keymap("x", "<Space>h", "<Plug>(quickhl-manual-this)", { silent = true })
      vim.api.nvim_set_keymap("n", "<Space>H", "<Plug>(quickhl-manual-reset)", { silent = true })
      vim.g.quickhl_manual_enable_at_startup = 1
      vim.g.quickhl_manual_keywords = { { pattern = pattern, regexp = 1 } }
    end,
  },
  {
    "kristijanhusak/line-notes.nvim",
    config = function()
      local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
      require("line-notes").setup({
        path = git_root .. "/line-notes.json",
        border_style = "none",
      })

      -- カーソル移動時にプレビューを表示
      vim.api.nvim_create_autocmd("CursorMoved", {
        callback = function()
          require("line-notes").preview()
        end,
      })

      vim.api.nvim_set_keymap("n", "<Space>n", ':lua require("line-notes").add()<CR>', { noremap = true })
      vim.api.nvim_set_keymap("n", "<Space>N", ':lua require("line-notes").delete()<CR>', { noremap = true })
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Ggrep", "GBrowse" },
    config = function()
      vim.cmd("cabbrev g Ggrep")
      vim.cmd("cabbrev l Git log --follow -p %")
    end,
  },
  { "tpope/vim-rhubarb" },
  {
    "airblade/vim-gitgutter",
    config = function()
      vim.cmd([[
    let g:gitgutter_git_executable = substitute(system('which git'), '\n\+$', '', '')
    ]])
    end,
  },
  {
    "rhysd/conflict-marker.vim",
    config = function()
      vim.cmd([[
    let g:conflict_marker_enable_mappings = 0
    ]])
    end,
  },
  { "tpope/vim-rails", ft = "ruby" },
  { "joker1007/vim-ruby-heredoc-syntax", ft = "ruby" },
  { "pocke/rbs.vim", ft = "ruby" },
  {
    "maxmellon/vim-jsx-pretty",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      vim.cmd([[
    let g:vim_jsx_pretty_colorful_config = 1
    let g:vim_jsx_pretty_highlight_close_tag = 1
    ]])
    end,
  },
  { "rhysd/vim-crystal", ft = "crystal" },
  { "slim-template/vim-slim", ft = "slim" },
  {
    "plasticboy/vim-markdown",
    ft = "markdown",
    config = function()
      vim.cmd([[
    " markdwonの折りたたみ無効化
    set nofoldenable
    let g:vim_markdown_folding_disabled = 1
    " markdown書くようの設定
    autocmd FileType markdown inoremap <Tab> <Esc>>>A
    autocmd FileType markdown inoremap <S-Tab> <Esc><<A
    let g:vim_markdown_conceal = 0
    ]])
    end,
  },
  {
    "mattn/emmet-vim",
    ft = "html",
    config = function()
      vim.cmd([[
    let g:user_emmet_leader_key='<C-Z>'
    " let g:user_emmet_install_global = 0
    " auletocmd FileType html,css,typescriptreact EmmetInstall
    ]])
    end,
  },
  { "cespare/vim-toml", ft = "toml" },
  { "mechatroner/rainbow_csv", ft = "csv" },
  { "aklt/plantuml-syntax", ft = "plantuml" },
  { "mtdl9/vim-log-highlighting" },
  { "hashivim/vim-terraform" },
  { "rizzatti/dash.vim" },
  -- { "github/copilot.vim", config = function()
  --   vim.api.nvim_set_keymap('i', '<C-f>', '<Plug>(copilot-next)', { silent = true })
  --   vim.api.nvim_set_keymap('i', '<C-l>', "copilot#Accept('<Right>')", { noremap = true, silent = true, expr = true })
  --   vim.api.nvim_set_keymap('i', '<Right>', "copilot#Accept('<Right>')", { noremap = true, silent = true, expr = true })
  --
  --   vim.g.copilot_no_tab_map = true
  -- end },
  -- { "CopilotC-Nvim/CopilotChat.nvim", branch = "main", dependencies = { "copilot.vim", "plenary.nvim" }, config = function()
  --   -- 参考: https://qiita.com/lx-sasabo/items/97c49d0f354ea3bdd525
  --
  --   local select = require('CopilotChat.select')
  --   require("CopilotChat").setup {
  --     debug = true, -- Enable debugging,
  --     highlight_selection = false, -- 選択範囲のハイライト
  --     show_help = true,
  --     mappings = {
  --       accept_diff = {
  --         normal = 'Y', -- デフォルトの<C-y>はtmuxと競合するので変更
  --       },
  --       reset = {
  --         normal = 'R', -- デフォルトの<C-l>はwindow移動と競合するので変更
  --       }
  --     },
  --     window = {
  --       width = 0.3,
  --     },
  --     -- プロンプトの設定
  --     prompts = {
  --       Review = {
  --         prompt = '/COPILOT_REVIEW このコードをレビューしてください。',
  --       },
  --       Commit = {
  --         prompt = '/COPILOT_COMMIT このコードのコミットメッセージを日本語で考えてください。',
  --       },
  --       Explain = {
  --         prompt = '/COPILOT_EXPLAIN カーソル上のコードの説明を段落をつけて書いてください。',
  --       },
  --       Tests = {
  --         prompt = '/COPILOT_TESTS カーソル上のコードの詳細な単体テスト関数を書いてください。',
  --       },
  --       Fix = {
  --         prompt = '/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き換えてください。',
  --       },
  --       Optimize = {
  --         prompt = '/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。',
  --       },
  --       Docs = {
  --         prompt = '/COPILOT_REFACTOR 選択したコードのドキュメントを書いてください。ドキュメントをコメントとして追加した元のコードを含むコードブロックで回答してください。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：JavaScriptのJSDoc、Pythonのdocstringsなど）',
  --       },
  --       FixDiagnostic = {
  --         prompt = 'ファイル内の次のような診断上の問題を解決してください：',
  --         selection = select.diagnostics,
  --       },
  --     }
  --   }
  --
  --   function CopilotChatBuffer()
  --     require("CopilotChat").toggle({
  --       selection = function(source)
  --         return select.visual(source) or select.buffer(source)
  --       end
  --     })
  --   end
  --   vim.api.nvim_set_keymap("n", "<F3>", "<cmd>lua CopilotChatBuffer()<cr>", { noremap = true, silent = true })
  --   vim.api.nvim_set_keymap("v", "<F3>", "<cmd>lua CopilotChatBuffer()<cr>", { noremap = true, silent = true })
  --
  --   -- telescope を使ってアクションプロンプトを表示する
  --   function ShowCopilotChatActionPrompt()
  --     local actions = require("CopilotChat.actions")
  --     require("CopilotChat.integrations.telescope").pick(actions.prompt_actions(), { initial_mode = "normal" })
  --   end
  --   vim.api.nvim_set_keymap("n", "<Leader>C", "<cmd>lua ShowCopilotChatActionPrompt()<cr>", { noremap = true, silent = true })
  -- end },
}
