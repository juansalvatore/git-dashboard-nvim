Config = {}

---@class Colors
---@field days_and_months_labels string
---@field empty_square_highlight string
---@field filled_square_highlights string[]
---@field branch_highlight string
---@field dashboard_title string

---@class Config
---@field fallback_header string
---@field top_padding number
---@field bottom_padding number
---@field use_git_username_as_author boolean
---@field author string ignored if use_git_username_as_author is true
---@field is_horizontal boolean
---@field branch string
---@field centered boolean
---@field gap string
---@field day_label_gap string
---@field empty string
---@field hide_cursor boolean
---@field empty_square string
---@field show_contributions_count boolean
---@field show_only_weeks_with_commits boolean
---@field filled_squares string[]
---@field title "owner_with_repo_name" | "repo_name" | "none"
---@field show_current_branch boolean
---@field days string[]
---@field months string[]
---@field use_current_branch boolean
---@field basepoints string[] remove commits from base branch, empty array to disable and show all commits
---@field colors Colors

---@type Config
local defaults = {
  fallback_header = "",
  top_padding = 0,
  bottom_padding = 0,
  use_git_username_as_author = false,
  author = "",
  branch = "main",
  gap = " ",
  day_label_gap = " ",
  empty = " ",
  empty_square = "□",
  filled_squares = { "■", "■", "■", "■", "■", "■" },
  hide_cursor = true,
  centered = true,
  is_horizontal = true,
  show_contributions_count = true,
  show_only_weeks_with_commits = false,
  title = "repo_name",
  show_current_branch = true,
  days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" },
  months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" },
  use_current_branch = true,
  basepoints = { "master", "main" },
  colors = {
    days_and_months_labels = "#7eac6f",
    empty_square_highlight = "#54734a",
    filled_square_highlights = { "#2a3925", "#54734a", "#7eac6f", "#98c689", "#afd2a3", "#bad9b0" },
    branch_highlight = "#8DC07C",
    dashboard_title = "#a3cc96",
  },
}

---@type Config
local current_config = defaults

---@param config table
Config.set_config_defaults = function(config)
  current_config = vim.tbl_deep_extend("force", current_config, config)
  return current_config
end

Config.get_config_defaults = function()
  return defaults
end

---@return Config
Config.get = function()
  return current_config
end

return Config
