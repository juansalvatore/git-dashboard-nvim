local heatmap = require("git-dashboard-nvim.git-heatmap")

M = {}

M.setup = function(config)
	return heatmap(config)
end

return M
