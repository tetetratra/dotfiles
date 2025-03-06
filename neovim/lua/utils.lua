function home()
  local start_column = vim.fn.col('.') -- 元のカラム番号を取得
  -- normal mode の ^ 相当の移動をする
  vim.cmd('normal! ^')
  -- 既に ^ 相当の移動後の位置にいる場合は 0 相当の移動をする
  if vim.fn.col('.') == start_column then
    vim.cmd('normal! 0')
  end
  return ''
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
  origin_url = origin_url:gsub("%s+$", "")  -- 改行除去

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
  vim.fn.setreg('+', github_url)
  vim.fn.system({"open", github_url})
end

function git_relative_filepath()
  -- 現在編集中のファイルの絶対パスを取得
  local filepath = vim.fn.expand('%:p')
  if filepath == '' then
    return ''
  end
  -- Git ルートディレクトリを取得（Git 管理下でない場合は空文字列になる）
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or ''
  if git_root == '' then
    -- Git 管理下でない場合は、相対パス（カレントディレクトリ基準）を返す
    return vim.fn.expand('%:.')
  end
  -- ファイルパスが git_root から始まる場合、git_root より後ろを返す
  if string.sub(filepath, 1, #git_root) == git_root then
    -- git_root とファイルパスの間の "/" 分を調整して返す
    return string.sub(filepath, #git_root + 2)
  else
    return vim.fn.expand('%:.')
  end
end

function toggle_virtual_edit()
  if vim.g.toggle_virtualedit == 0 then
    vim.g.toggle_virtualedit = 1
    vim.o.virtualedit = 'block'
    print('virtualedit=block')
  else
    vim.g.toggle_virtualedit = 0
    vim.o.virtualedit = 'none'
    print('virtualedit=none')
  end
end

function toggle_transparent()
  local bg = vim.api.nvim_get_hl_by_name('Normal', true).background
  if bg then -- 退避 & 透明化
    vim.g.saved_normal_guibg = bg
    vim.api.nvim_set_hl(0, 'Normal', { background = 'NONE' })
    print('background color disabled')
  else -- 復元
    vim.api.nvim_set_hl(0, 'Normal', { background = vim.g.saved_normal_guibg })
    print('background color enabled')
  end
end

function jump_gf_lsp_tag()
    -- coc-definition を試す
    local jump_success = false
    local ok, _ = pcall(function() -- エラーハンドリング付きで実行
      jump_success = vim.fn.CocAction('jumpDefinition')
    end)
    if ok and jump_success then
      print("[lsp]")
      return
    end

    -- gf (Vim-Rails の拡張込み) を試す
    local ok, _ = pcall(function() -- エラーハンドリング付きで実行
      vim.cmd('normal gf')
    end)
    if ok then
      print("[vim-rails]")
      return
    end

    -- tagジャンプ を試す
    ok, _ = pcall(function()
        vim.cmd('tag ' .. vim.fn.expand('<cword>'))
    end)
    if ok then
      print("[tag]")
      return
    end

    print("No LSP definition or file or tag found.")
end

function my_tab_line()
    local s = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local buflist = vim.fn.tabpagebuflist(i) -- タブ内のバッファリストを取得
        local win_index = vim.fn.tabpagewinnr(i) -- アクティブなウィンドウのインデックス
        local bufnr = buflist[win_index]         -- アクティブなバッファ番号
        -- 無効なバッファ番号チェック
        if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            local bufname = vim.fn.bufname(bufnr)
            local bufpath = bufname ~= "" and bufname or "[No Name]"
            -- Git のルートディレクトリが存在する場合、相対パスを取得
            if git_root and bufpath:find(git_root, 1, true) then
                bufpath = bufpath:sub(#git_root + 2)  -- Git ルートからの相対パスを取得
            end
            -- 現在のタブとそれ以外で色を分ける
            if i == vim.fn.tabpagenr() then
                s = s .. "%" .. i .. "T%#TabLineSel# " .. i .. ": " .. bufpath .. " %#TabLine#"
            else
                s = s .. "%" .. i .. "T%#TabLine# " .. i .. ": " .. bufpath .. " %#TabLine#"
            end
        else
            s = s .. "%" .. i .. "T%#TabLine# " .. i .. ": [Invalid Buffer] %#TabLine#"
        end
    end
    return s
end
vim.cmd("highlight TabLineSel guifg=#cccccc guibg=#333333 gui=bold")
vim.cmd("highlight TabLine guifg=#aaaaaa guibg=#222222")
