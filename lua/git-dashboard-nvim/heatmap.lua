local Git = require("git-dashboard-nvim.git")

M = {}

M.generate_heatmap = function(config)
	local author = config.author or ""
	local branch = config.branch or "main"

	local empty_square = config.empty_square or "□"
	local filled_square = config.filled_square or "■"

	local show_repo_name = config.show_repo_name or false
	local title = config.title or "repo_name"
	local show_current_branch = config.show_current_branch or true
	local use_current_branch = config.use_current_branch or true

	if use_current_branch then
		branch = Git.get_current_branch()
	end

	local should_cache = config.should_cache or false
	local cache_time = config.cache_time or 600

	local gap = config.gap or " "
	local day_label_gap = config.day_label_gap or " "

	-- get repo with owner and commits
	local repo = Git.get_repo_with_owner() -- owner/repo

	if repo == "" or not repo then
		return ""
	end

	local commits = Git.get_commit_dates(author, branch)

	local heatmap = {}

	local weeks_in_year = 52
	local days_in_week = 7

	local current_week = tonumber(os.date("%U"))
	local current_day_of_week = tonumber(os.date("%w"))

	for i = 1, weeks_in_year do
		heatmap[i] = {}

		for j = 1, days_in_week do
			heatmap[i][j] = 0
		end

		if i == current_week then
			break
		end
	end

	for _, commit_date in ipairs(commits) do
		-- if commit date is in the future or before January 1st of current year, then skip
		local week = commit_date.week
		local day_of_week = commit_date.day_of_week + 1

		if not heatmap[week] then
			heatmap[week] = {}
		end

		if not heatmap[week][day_of_week] then
			heatmap[week][day_of_week] = 0
		end

		heatmap[week][day_of_week] = heatmap[week][day_of_week] + 1
	end

	local ascii_heatmap = ""

	local empty = " "

	local days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }

	local months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
	local current_month = os.date("%m")

	-- if show_repo_name then
	if title == "owner_with_repo_name" then
		ascii_heatmap = ascii_heatmap .. repo .. "\n\n"
	elseif title == "repo_name" then
		-- extract repo name from owner/repo
		local repo_name = repo:match("([^/]+)$")
		ascii_heatmap = ascii_heatmap .. repo_name .. "\n\n"
	else
		ascii_heatmap = ascii_heatmap .. "\n\n"
	end

	if #gap == 1 then
		ascii_heatmap = ascii_heatmap .. " "
		for i = 1, current_month do
			ascii_heatmap = ascii_heatmap .. "   " .. gap .. months[i] .. " "
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

	for i = 1, days_in_week do
		ascii_heatmap = ascii_heatmap .. days[i] .. day_label_gap

		-- if day in week is higher than current day of week, then it's in the future and we don't need to print it
		for j = 1, #heatmap do
			if j == tonumber(current_week) and i > tonumber(current_day_of_week) + 1 then
				-- continue
				ascii_heatmap = ascii_heatmap .. empty .. gap
			elseif heatmap[j][i] > 0 then
				ascii_heatmap = ascii_heatmap .. filled_square .. gap
			else
				ascii_heatmap = ascii_heatmap .. empty_square .. gap
			end
		end

		ascii_heatmap = ascii_heatmap .. "\n"
	end

	if show_current_branch then
		ascii_heatmap = ascii_heatmap .. "\n" .. " " .. branch
	end

	return ascii_heatmap
end

return M
