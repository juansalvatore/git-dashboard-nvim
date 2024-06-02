local heatmap = require("git-dashboard-nvim.git-heatmap")

M = {}

M.setup = function(config)
	local fallback_header = config.fallback_header or ""
	local ascii_heatmap = heatmap.generate_heatmap(config)

	if ascii_heatmap == "" then
		if fallback_header ~= "" then
			ascii_heatmap = fallback_header
		else
			ascii_heatmap = string.rep("---\n", 10)
		end
	end

	local top_padding = config.top_padding or 0
	local bottom_padding = config.bottom_padding or 0

	-- create an autocommand on BufWritePost when a command is ran using :! to call the dashboard redraw from require('dashboard')
	vim.api.nvim_create_autocmd({ "ShellCmdPost" }, {
		callback = function()
			vim.cmd("silent! Lazy reload dashboard-nvim")

			-- make buffer modifiable
			vim.bo.modifiable = true
			vim.cmd("silent! %d")
			vim.cmd("silent! Dashboard")
		end,
	})

	return vim.split(string.rep("\n", top_padding) .. ascii_heatmap .. string.rep("\n", bottom_padding), "\n")
end

return M
