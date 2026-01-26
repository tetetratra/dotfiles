function home()
  local start_column = vim.fn.col(".") -- 元のカラム番号を取得
  -- normal mode の ^ 相当の移動をする
  vim.cmd("normal! ^")
  -- 既に ^ 相当の移動後の位置にいる場合は 0 相当の移動をする
  if vim.fn.col(".") == start_column then
    vim.cmd("normal! 0")
  end
  return ""
end

function write_last_messages_to_new_buffer()
  vim.cmd("enew")

  -- 読み取り専用を解除（必要なら）
  vim.bo.readonly = false
  vim.bo.buftype = ""

  local messages = vim.fn.execute("messages")
  local lines = vim.split(messages, "\n")

  -- メッセージを書き込み
  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
end

function get_github_url()
  -- 現在開いているバッファのファイルパスを相対パスに変換
  local filepath = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:.")

  -- カレントディレクトリ取得
  local current_dir = vim.fn.expand("%:p:h")

  -- originのURL取得
  local origin_url = vim.fn.system("git -C " .. current_dir .. " remote get-url origin")
  origin_url = origin_url:gsub("%s+$", "") -- 改行除去

  -- ブランチ名取得
  local branch = vim.fn.system("git -C " .. current_dir .. " symbolic-ref --short HEAD")
  branch = branch:gsub("%s+$", "")

  -- URLから org/repo を抽出 (https/SSH 両対応)
  local org_repo = origin_url:match("github.com[:/](.+)%.git")
  if not org_repo then
    print("GitHubリポジトリではない可能性があります")
    return nil
  end

  -- GitHubファイルURLを構築
  local github_url = "https://github.com/" .. org_repo .. "/blob/" .. branch .. "/" .. filepath

  print(github_url)
  vim.fn.setreg("+", github_url)
  vim.fn.system({ "open", github_url })
end

function git_relative_filepath()
  -- 現在編集中のファイルの絶対パスを取得
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    return ""
  end
  -- Git ルートディレクトリを取得（Git 管理下でない場合は空文字列になる）
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or ""
  if git_root == "" then
    -- Git 管理下でない場合は、相対パス（カレントディレクトリ基準）を返す
    return vim.fn.expand("%:.")
  end
  -- ファイルパスが git_root から始まる場合、git_root より後ろを返す
  if string.sub(filepath, 1, #git_root) == git_root then
    -- git_root とファイルパスの間の "/" 分を調整して返す
    return string.sub(filepath, #git_root + 2)
  else
    return vim.fn.expand("%:.")
  end
end

function toggle_virtual_edit()
  if vim.g.toggle_virtualedit == 0 then
    vim.g.toggle_virtualedit = 1
    vim.o.virtualedit = "block"
    print("virtualedit=block")
  else
    vim.g.toggle_virtualedit = 0
    vim.o.virtualedit = "none"
    print("virtualedit=none")
  end
end

-- メッセージを表示して指定時間後に自動的にクリアする
local function print_with_timeout(msg, timeout_ms)
  print(msg)
  vim.defer_fn(function()
    vim.cmd('echon ""')
  end, timeout_ms or 1000)
end

function jump_gf_lsp_tag()
  if vim.bo.filetype == "" then -- 空のバッファ等でfiletyepeが設定されていない場合は決め打ちでrubyにする
    vim.bo.filetype = "ruby"
  end

  -- coc-definition を試す
  local jump_success = false
  local ok, _ = pcall(function() -- エラーハンドリング付きで実行
    jump_success = vim.fn.CocAction("jumpDefinition")
  end)
  if ok and jump_success then
    print_with_timeout("[lsp]")
    return
  end

  -- gf (Vim-Rails の拡張込み) を試す
  local ok, _ = pcall(function() -- エラーハンドリング付きで実行
    vim.cmd("normal gf")
  end)
  if ok then
    print_with_timeout("[vim-rails]")
    return
  end

  -- tagジャンプ を試す
  ok, _ = pcall(function()
    vim.cmd("tag " .. vim.fn.expand("<cword>"))
  end)
  if ok then
    print_with_timeout("[tag]")
    return
  end

  print_with_timeout("No LSP definition or file or tag found.")
end

-- バッファ単位で Git ルートをキャッシュ
local function get_git_root(bufnr)
  if vim.b[bufnr].git_root_cached then return vim.b[bufnr].git_root_cached end

  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then return nil end             -- 未保存

  local dir  = vim.fn.fnamemodify(path, ":p:h")
  local git_dir = vim.fn.finddir(".git", dir .. ";")
  if git_dir ~= "" then
    local root = vim.fn.fnamemodify(git_dir, ":h")
    vim.b[bufnr].git_root_cached = root
    return root
  end
  vim.b[bufnr].git_root_cached = false  -- Git外
  return nil
end

function my_tab_line()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local buflist   = vim.fn.tabpagebuflist(i)
    local win_index = vim.fn.tabpagewinnr(i)
    local bufnr     = buflist[win_index]

    local bufname = (bufnr and vim.api.nvim_buf_is_valid(bufnr))
                   and vim.fn.bufname(bufnr) or ""
    local bufpath = bufname ~= "" and bufname or "[No Name]"

    local root = bufnr and get_git_root(bufnr) or nil
    if root then
      -- root の末尾に / をつけて、"root/" だけを削る
      local prefix = root
      if prefix:sub(-1) ~= "/" then
        prefix = prefix .. "/"
      end

      if bufpath:sub(1, #prefix) == prefix then
        -- prefix 部分（例: "/Users/you/" や "/"）だけを削る
        bufpath = bufpath:sub(#prefix + 1)
      end
    end

    local filename = vim.fn.fnamemodify(bufpath, ":t")

    local highlight = (i == vim.fn.tabpagenr()) and "%#TabLineSel#" or "%#TabLine#"
    -- s = s .. "%"..i.."T"..highlight.." "..i.." "..bufpath.." %#TabLine#"
    s = s .. "%T"..highlight.." "..filename.." %#TabLineNone# %#TabLine#"
  end
  return s .. "%#TabLineNone#"
end
vim.cmd("highlight TabLineSel guifg=#cccccc guibg=#506070 gui=bold")
vim.cmd("highlight TabLine guifg=#aaaaaa guibg=#303030")
vim.cmd("highlight TabLineNone guifg=none guibg=#202020")

function tab_clone_with_cursor()
  -- tabnew % だとカーソル位置がリセットされてしまうので、カーソル位置を保存してからtabnewする
  local pos = vim.fn.getpos(".")
  vim.cmd("tabnew %")
  vim.fn.setpos(".", pos)
end
