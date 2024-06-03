M = {}

---@class Config
---@field fallback_header string
---@field top_padding number
---@field bottom_padding number
---@field author string
---@field branch string
---@field gap string
---@field day_label_gap string
---@field empty string
---@field empty_square string
---@field filled_square string
---@field title "owner_with_repo_name" | "repo_name" | "none
---@field show_current_branch boolean
---@field days string[]
---@field months string[]
---@field use_current_branch boolean

---@type Config
local defaults = {
	fallback_header = "",
	top_padding = 0,
	bottom_padding = 0,
	author = "",
	branch = "main",
	gap = " ",
	day_label_gap = " ",
	empty = " ",
	empty_square = "□",
	filled_square = "■",
	title = "repo_name",
	show_current_branch = true,
	days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" },
	months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" },
	use_current_branch = true,
}

---@param config table
M.set_config_defaults = function(config)
	for k, v in pairs(defaults) do
		if config[k] == nil then
			config[k] = v
		end
	end

	---@type Config
	return config
end

return M
