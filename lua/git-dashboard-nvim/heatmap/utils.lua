local utils = require("git-dashboard-nvim.utils")

M = {}

M.generate_base_heatmap = function(dates)
	local heatmap = {}
	local date_info = utils.current_date_info()

	-- create base heatmap
	for i = 1, date_info.weeks_in_year do
		heatmap[i] = {}

		for j = 1, date_info.days_in_week do
			heatmap[i][j] = 0
		end

		if i == date_info.current_week then
			break
		end
	end

	for _, date in ipairs(dates) do
		-- if commit date is in the future or before January 1st of current year, then skip
		local week = date.week
		local day_of_week = date.day_of_week + 1

		if not heatmap[week] then
			heatmap[week] = {}
		end

		if not heatmap[week][day_of_week] then
			heatmap[week][day_of_week] = 0
		end

		heatmap[week][day_of_week] = heatmap[week][day_of_week] + 1
	end

	return heatmap
end

---@param base_heatmap number[][]
---@param config Config
---@param repo_with_owner string
---@return string
M.generate_ascii_heatmap = function(base_heatmap, config, repo_with_owner)
	local date_info = utils.current_date_info()
	local ascii_heatmap = ""

	if config.title == "owner_with_repo_name" then
		ascii_heatmap = ascii_heatmap .. repo_with_owner .. "\n\n"
	elseif config.title == "repo_name" then
		-- extract repo name from owner/repo
		local repo_name = repo_with_owner:match("([^/]+)$")
		ascii_heatmap = ascii_heatmap .. repo_name .. "\n\n"
	else
		ascii_heatmap = ascii_heatmap .. "\n\n"
	end

	if #config.gap == 1 then
		ascii_heatmap = ascii_heatmap .. " "
		for i = 1, date_info.current_month do
			ascii_heatmap = ascii_heatmap .. "   " .. config.gap .. config.months[i] .. " "
		end

		-- ascii_heatmap = ascii_heatmap .. "ooo" .. gap

		-- if last week of the month add extra spacing
		-- if #heatmap < weeks_in_year then
		-- 	ascii_heatmap = ascii_heatmap .. "EE"
		-- end
		ascii_heatmap = ascii_heatmap .. "\n"
	else
		ascii_heatmap = ascii_heatmap .. "\n"
	end

	for i = 1, date_info.days_in_week do
		ascii_heatmap = ascii_heatmap .. config.days[i] .. config.day_label_gap

		-- if day in week is higher than current day of week, then it's in the future and we don't need to print it
		for j = 1, #base_heatmap do
			if j == tonumber(date_info.current_week) and i > tonumber(date_info.current_day_of_week) + 1 then
				-- continue
				ascii_heatmap = ascii_heatmap .. config.empty .. config.gap
			elseif base_heatmap[j][i] > 0 then
				-- vim.cmd("match FilledSquareHighlight /" .. config.filled_square .. "/")
				-- ascii_heatmap = ascii_heatmap .. config.filled_square .. config.gap

				-- do from 1 to 5 FilledSquareHighlight1 to FilledSquareHighlight5
				if base_heatmap[j][i] == 1 then
					vim.cmd("match FilledSquareHighlight1 /" .. config.filled_square .. "/")
					ascii_heatmap = ascii_heatmap .. config.filled_square .. config.gap
				elseif base_heatmap[j][i] == 2 then
					vim.cmd("match FilledSquareHighlight2 /" .. config.filled_square .. "/")
					ascii_heatmap = ascii_heatmap .. config.filled_square .. config.gap
				elseif base_heatmap[j][i] == 3 then
					vim.cmd("match FilledSquareHighlight3 /" .. config.filled_square .. "/")
					ascii_heatmap = ascii_heatmap .. config.filled_square .. config.gap
				elseif base_heatmap[j][i] == 4 then
					vim.cmd("match FilledSquareHighlight4 /" .. config.filled_square .. "/")
					ascii_heatmap = ascii_heatmap .. config.filled_square .. config.gap
				else
					vim.cmd("match FilledSquareHighlight5 /" .. config.filled_square .. "/")
					ascii_heatmap = ascii_heatmap .. config.filled_square .. config.gap
				end
			else
				ascii_heatmap = ascii_heatmap .. config.empty_square .. config.gap
			end
		end

		ascii_heatmap = ascii_heatmap .. "\n"
	end

	if config.show_current_branch then
		ascii_heatmap = ascii_heatmap .. "\n" .. " " .. config.branch
	end

	vim.cmd("highlight FilledSquareHighlight1 guifg=#FF0000")
	vim.cmd("highlight FilledSquareHighlight2 guifg=#FFA500")
	vim.cmd("highlight FilledSquareHighlight3 guifg=#FFFF00")
	vim.cmd("highlight FilledSquareHighlight4 guifg=#00FF00")
	vim.cmd("highlight FilledSquareHighlight5 guifg=#0000FF")

	return ascii_heatmap
end

return M
