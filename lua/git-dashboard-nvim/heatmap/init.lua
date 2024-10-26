local Git = require("git-dashboard-nvim.git")
local HeatmapUtils = require("git-dashboard-nvim.heatmap.utils")
local utils = require("git-dashboard-nvim.utils")

Heatmap = {}

---@param config Config
---@return string
Heatmap.generate_heatmap = function(config)
  if config.use_current_branch then
    config.branch = Git.get_current_branch()
  end

  -- get repo with owner and commits
  local repo_with_owner = Git.get_repo_with_owner() -- owner/repo

  if repo_with_owner == "" or not repo_with_owner then
    repo_with_owner = vim.fn.getcwd()
  end

  local author = config.author
  if config.use_git_username_as_author then
    author = Git.get_username()
  end

  local commits = Git.get_commit_dates(author, config.branch)

  local current_date_info = utils.current_date_info()

  local base_heatmap = HeatmapUtils.generate_base_heatmap(commits, current_date_info)

  local ascii_heatmap =
    HeatmapUtils.generate_ascii_heatmap(base_heatmap, config, repo_with_owner, current_date_info)
  return ascii_heatmap
end

return Heatmap
