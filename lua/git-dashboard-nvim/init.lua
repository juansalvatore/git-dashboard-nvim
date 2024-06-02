local utils = require("git-dashboard-nvim.utils")
local heatmap = require("git-dashboard-nvim.heatmap")

M = {}

M.setup = function(config)
	local fallback_header = config.fallback_header or ""
	local ascii_heatmap = heatmap.generate_heatmap(config)

	if ascii_heatmap == "" then
		if fallback_header ~= "" then
			ascii_heatmap = fallback_header
		else
			ascii_heatmap = string.rep("\n", 10)
		end
	end

	local top_padding = config.top_padding or 0
	local bottom_padding = config.bottom_padding or 0

	utils.create_dashboard_update_on_shell_cmd()

	return vim.split(string.rep("\n", top_padding) .. ascii_heatmap .. string.rep("\n", bottom_padding), "\n")
end

return M
