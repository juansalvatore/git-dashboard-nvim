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
---@field author string
---@field is_horizontal boolean
---@field branch string
---@field gap string
---@field day_label_gap string
---@field empty string
---@field empty_square string
---@field show_contributions_count boolean
---@field show_only_weeks_with_commits boolean
---@field filled_squares string[]
---@field title "owner_with_repo_name" | "repo_name" | "none"
---@field show_current_branch boolean
---@field days string[]
---@field months string[]
---@field use_current_branch boolean
---@field colors Colors

---@type Config
local defaults = {
  fallback_header = "",
  top_padding = 0,
  bottom_padding = 0,
  author = "",
  branch = "main",
  gap = " ",
  day_label_gap = " ",
  empty = " ",
  empty_square = "□",
  -- filled_squares = { "", "", "", "", "", "" },
  filled_squares = { "■", "■", "■", "■", "■", "■" },
  is_horizontal = true,
  show_contributions_count = true,
  show_only_weeks_with_commits = false,
  title = "repo_name",
  show_current_branch = true,
  days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" },
  months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" },
  use_current_branch = true,
  colors = {
    days_and_months_labels = "#7eac6f",
    empty_square_highlight = "#54734a",
    filled_square_highlights = { "#2a3925", "#54734a", "#7eac6f", "#98c689", "#afd2a3", "#bad9b0" },
    branch_highlight = "#8DC07C",
    dashboard_title = "#a3cc96",
  },
}

---@param config table
Config.set_config_defaults = function(config)
  return vim.tbl_deep_extend("force", defaults, config)
end

Config.get_config_defaults = function()
  return defaults
end

return Config
