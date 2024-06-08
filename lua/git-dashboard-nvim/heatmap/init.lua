local Git = require("git-dashboard-nvim.git")
local HeatmapUtils = require("git-dashboard-nvim.heatmap.utils")

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
    return ""
  end

  local commits = Git.get_commit_dates(config.author, config.branch)

  if #commits == 0 then
    return ""
  end

  local base_heatmap = HeatmapUtils.generate_base_heatmap(commits)

  local ascii_heatmap = HeatmapUtils.generate_ascii_heatmap(base_heatmap, config, repo_with_owner)
  return ascii_heatmap
end

return Heatmap
