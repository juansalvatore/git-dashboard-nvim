local heatmap = require("git-dashboard-nvim.git-heatmap")

M = {}

M.setup = function(config)
	local ascii_heatmap = heatmap(config)
	local top_padding = config.top_padding or 0
	local bottom_padding = config.bottom_padding or 0

	return vim.split(string.rep("\n", top_padding) .. ascii_heatmap .. string.rep("\n", bottom_padding), "\n")
end

return M
