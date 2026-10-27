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

      -- root 配下（深さ3まで）にあるディレクトリへのシンボリックリンクを、{ path = リンクのパス, real = 実パス } のリストで返す
      local function find_dir_links(root)
        local links = {}
        local skip_dirs = { [".git"] = true, ["node_modules"] = true }
        for name, type in vim.fs.dir(root, {
          depth = 3,
          skip = function(dir) return not skip_dirs[vim.fs.basename(dir)] end,
        }) do
          if type == "link" then
            local link_path = root .. "/" .. name
            local real = vim.uv.fs_realpath(link_path)
            if real and vim.fn.isdirectory(real) == 1 then
              table.insert(links, { path = link_path, real = real })
            end
          end
        end
        return links
      end

      -- ルート外の実パス（telescope から開いた場合など）を、ルート配下のシンボリックリンク経由のパスに読み替える。
      -- 該当するリンクが見つからなければ path をそのまま返す
      local function to_link_path(path, root, links)
        if vim.startswith(path, root .. "/") then return path end
        local real_path = vim.uv.fs_realpath(path) or path
        for _, link in ipairs(links) do
          if vim.startswith(real_path, link.real .. "/") then
            return link.path .. real_path:sub(#link.real + 1)
          end
        end
        return path
      end

      -- dir と、その配下のシンボリックリンク先のそれぞれで git ls-ss を並列に実行し、出力されたパスを絶対パスで返す。
      -- リンク先は別リポジトリのことが多く、dir での git ls-ss には現れないため
      local function git_ls_ss_paths(dir, links)
        local jobs = {}
        for _, d in ipairs(vim.list_extend({ dir }, vim.tbl_map(function(link) return link.path end, links))) do
          table.insert(jobs, { dir = d, job = vim.system({ "git", "ls-ss" }, { cwd = d, text = true }) })
        end

        local paths = {}
        for _, j in ipairs(jobs) do
          for line in (j.job:wait().stdout or ""):gmatch("[^\n]+") do
            table.insert(paths, j.dir .. "/" .. (line:gsub("/$", "")))
          end
        end
        return paths
      end

      -- ; で開くツリーに残すパスの集合。open_nvim_tree_floating を呼ぶたびに作り直す
      local floating_targets = {}

      -- floating_targets のどれとも一致せず、どれの祖先ディレクトリでもないパスを隠す。
      -- nvim-tree はリンクのディレクトリ自体をリンク経由のパスで、その配下を実パスで判定するため、
      -- floating_targets には両方の形のパスを入れておく（組み込みの no_buffer フィルタはこれに対応していない）
      local function hide_non_floating_target(path)
        for target in pairs(floating_targets) do
          if target == path or vim.startswith(target, path .. "/") then return false end
        end
        return true
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
            custom = hide_non_floating_target, -- 変更ファイルと開いているファイルだけを表示する（U で切り替え）
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

        local root = vim.fn.getcwd()
        local links = find_dir_links(root)

        -- 変更のあったファイルもバッファに読み込んでおく
        for _, path in ipairs(git_ls_ss_paths(root, links)) do
          if vim.fn.bufnr(path) == -1 then
            vim.cmd("silent! badd " .. vim.fn.fnameescape(path))
          end
        end

        floating_targets = {}
        for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
          if buf.name ~= "" then
            local real = vim.uv.fs_realpath(buf.name) or buf.name
            floating_targets[buf.name] = true
            floating_targets[real] = true
            floating_targets[to_link_path(real, root, links)] = true
          end
        end

        api.tree.open()
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

      -- ツリーのルートから path の親ディレクトリまでを順に展開する。
      -- シンボリックリンクのディレクトリまで展開すれば、その先は find_file が link_to をたどって探せる
      local function expand_parents_by_link_path(path)
        local explorer = require("nvim-tree.core").get_explorer()
        if path == "" or not explorer then return end
        local root = explorer.absolute_path
        path = to_link_path(path, root, find_dir_links(root))
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
