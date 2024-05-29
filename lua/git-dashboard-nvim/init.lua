local heatmap = require("git-dashboard-nvim.git-heatmap")

M = {}

M.setup = function(config)
	local ascii_heatmap = heatmap(config)
	return vim.split(ascii_heatmap, "\n")
end

return M
