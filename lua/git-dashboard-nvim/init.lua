local heatmap = require("git-dashboard-nvim.git-heatmap")

M = {}

M.setup = function()
	return heatmap()
end

return M
