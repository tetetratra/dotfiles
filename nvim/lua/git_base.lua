-- バッファのファイルが属するリポジトリについて、デフォルトブランチ（developやmainなど）との分岐点を求める
-- サインカラム（gitsigns）で、PRに入る差分の比較対象として使う
local M = {}

-- デフォルトブランチが分からないときに、この順に存在するものを使う
local FALLBACK_BRANCHES = { 'develop', 'main', 'master' }

---@param dir string
---@param args string[]
---@return string?
local function git(dir, args)
  local result = vim.system(vim.list_extend({ 'git', '-C', dir }, args), { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end
  return vim.trim(result.stdout or '')
end

---@param bufnr integer
---@return { repo: string, branch: string, merge_base: string }?
function M.get(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == '' then
    return nil
  end

  -- シンボリックリンク経由で開いた別リポジトリのファイルでも、そのリポジトリを対象にするため実体パスを使う
  local dir = vim.fn.fnamemodify(vim.fn.resolve(file), ':h')
  if vim.fn.isdirectory(dir) == 0 then
    return nil
  end
  local repo = git(dir, { 'rev-parse', '--show-toplevel' })
  if not repo then
    return nil
  end

  -- origin/HEADはclone時に設定されるGitHubのデフォルトブランチ（PRの宛先の既定）を指す
  -- GitHub側で変えた場合は `git remote set-head origin -a` で更新する
  local candidates = {}
  local remote_head = git(repo, { 'symbolic-ref', '--short', 'refs/remotes/origin/HEAD' })
  if remote_head then
    table.insert(candidates, (remote_head:gsub('^origin/', '')))
  end
  vim.list_extend(candidates, FALLBACK_BRANCHES)

  -- ローカルのブランチを優先し、なければリモート追跡ブランチを使う
  for _, name in ipairs(candidates) do
    for _, ref in ipairs({ name, 'origin/' .. name }) do
      if git(repo, { 'rev-parse', '--verify', '--quiet', ref .. '^{commit}' }) then
        local merge_base = git(repo, { 'merge-base', ref, 'HEAD' })
        if merge_base then
          return { repo = repo, branch = ref, merge_base = merge_base }
        end
      end
    end
  end
  return nil
end

return M
