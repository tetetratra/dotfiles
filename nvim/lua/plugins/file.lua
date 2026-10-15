-- ファイラー
return {
  {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({
        actions = {
          open_file = {
            resize_window = false,
          },
        },
        filters = {
          git_ignored = false, -- .gitignore されたファイルも最初から表示する（I で切り替え）
        },
        view = {
          width = 40,
          preserve_window_proportions = true,
        },
      })
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
          actions = {
            open_file = {
              resize_window = false,
            },
          },
          filters = {
            git_ignored = false, -- .gitignore されたファイルも最初から表示する（I で切り替え）
          },
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
            preserve_window_proportions = true,
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

      -- カレントバッファの絶対パスを、シンボリックリンクを解決せずに返す
      -- （expand("%:p") はディレクトリのシンボリックリンクを実パスに解決してしまう）
      local function current_buf_link_path()
        local name = vim.fn.bufname()
        if name == "" then return "" end
        if name:sub(1, 1) == "/" then return name end
        return vim.fs.normalize(vim.fs.joinpath(vim.fn.getcwd(), name))
      end

      -- ルート外の実パス（telescope から開いた場合など）を、ルート配下のシンボリックリンク経由のパスに読み替える。
      -- 該当するリンクが見つからなければ path をそのまま返す
      local function to_link_path(path, root)
        if vim.startswith(path, root .. "/") then return path end
        local real_path = vim.uv.fs_realpath(path) or path
        local skip_dirs = { [".git"] = true, ["node_modules"] = true }
        for name, type in vim.fs.dir(root, {
          depth = 3,
          skip = function(dir) return not skip_dirs[vim.fs.basename(dir)] end,
        }) do
          if type == "link" then
            local link_path = root .. "/" .. name
            local link_to = vim.uv.fs_realpath(link_path)
            if link_to and vim.startswith(real_path, link_to .. "/") then
              return link_path .. real_path:sub(#link_to + 1)
            end
          end
        end
        return path
      end

      -- ツリーのルートから path の親ディレクトリまでを順に展開する。
      -- シンボリックリンクのディレクトリまで展開すれば、その先は find_file が link_to をたどって探せる
      local function expand_parents_by_link_path(path)
        local explorer = require("nvim-tree.core").get_explorer()
        if path == "" or not explorer then return end
        local root = explorer.absolute_path
        path = to_link_path(path, root)
        if not vim.startswith(path, root .. "/") then return end

        local dir = root
        local parts = vim.split(path:sub(#root + 2), "/", { plain = true })
        for i = 1, #parts - 1 do
          dir = dir .. "/" .. parts[i]
          local node = explorer:get_node_from_path(dir)
          if not node or not node.nodes then break end
          if #node.nodes == 0 then explorer:expand_dir_node(node) end
          node.open = true
          if node.link_to then break end
        end
        explorer.renderer:draw()
      end

      function open_nvim_tree_left()
        if api.tree.is_visible() then
          api.tree.close()
          return
        end

        require("nvim-tree").setup({
          actions = {
            open_file = {
              resize_window = false,
            },
          },
          filters = {
            git_ignored = false, -- .gitignore されたファイルも最初から表示する（I で切り替え）
          },
          view = {
            float = {
              enable = false,
            },
            side = "left",
            width = 40,
            adaptive_size = false,
            preserve_window_proportions = true,
          },
        })

        local path = current_buf_link_path()
        api.tree.open({ find_file = true, focus = true })
        -- find_file は実パスで探すため、シンボリックリンク経由のファイルを見つけられない。
        -- リンク経由のパスで親ディレクトリを先に展開してから、改めて探す
        expand_parents_by_link_path(path)
        api.tree.find_file({ buf = path })
      end

      vim.keymap.set("n", ";",    open_nvim_tree_floating, { desc = "NvimTree: Floating" })
      vim.keymap.set("n", "<F2>", open_nvim_tree_left, { desc = "NvimTree: Normal Left" })



    end,
  },
  { 'ryanoasis/vim-devicons' },
  { 'bogado/file-line' },
}
