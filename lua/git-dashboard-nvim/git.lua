local utils = require("git-dashboard-nvim.utils")

Git = {}

---@return string
Git.get_repo_with_owner = function()
  local handle = io.popen("git remote get-url origin 2>/dev/null")
  if not handle then
    return ""
  end

  local remote_url = handle:read("*a")
  handle:close()

  if remote_url and remote_url ~= "" then
    remote_url = remote_url:gsub("%s+", "") -- Remove any trailing newlines or spaces

    local name_with_owner = remote_url:match("github%.com[:/]([^/]+/[^/.]+)%.git")
      or remote_url:match("github%.com[:/]([^/]+/[^/.]+)")
    if name_with_owner then
      return name_with_owner
    end
  end

  return ""
Git.get_username = function()
  local handle = io.popen("git config user.name")
  if not handle then
    return ""
  end

  local username = handle:read("*a")
  return utils.trim(username)
end

---@param username string
---@param _branch string
---@return table
Git.get_commit_dates = function(username, _branch)
  local commits = {}

  local current_year = tostring(os.date("%Y"))

  local since_date = os.date("%Y-%m-%d", os.time({ year = current_year, month = 1, day = 1 }))

  local branch = _branch

  if _branch == "main" then
    branch = _branch
  else
    branch = branch .. " --not origin/main"
  end

  local git_command = string.format(
    "git log "
      .. branch
      .. ' --author="%s" --since="'
      .. since_date
      .. '" --date=format:"%%Y-%%m-%%dT%%H:%%M:%%SZ" --pretty=format:"%%ad"',
    username
  )

  local handle = io.popen(git_command)

  if not handle then
    return commits
  end

  -- Read output line by line and parse date
  for line in handle:lines() do
    local date = utils.parse_date(line)
    table.insert(commits, date)
  end

  handle:close()

  return commits
end

---@return string
Git.get_current_branch = function()
  local handle = io.popen("git branch --show-current 2>/dev/null")
  if not handle then
    return ""
  end

  local branch = handle:read("*a")
  handle:close()

  if branch and branch ~= "" then
    return branch:gsub("%s+", "") -- Remove any trailing newlines or spaces
  end

  return ""
end

return Git
