local GitHubAPI = require("git-dashboard-nvim.githubapi")

local function main(config)
	local author = config.author or ""
	local branch = config.branch or "main"

	local empty_square = config.empty_square or "□"
	local filled_square = config.filled_square or "■"
	local show_repo_name = config.show_repo_name or true

	local should_cache = config.should_cache or false
	local cache_time = config.cache_time or 600

	local gap = config.gap or " "
	local day_label_gap = config.day_label_gap or " "

	-- get repo with owner and commits
	local repo = GitHubAPI.get_repo_with_owner() -- owner/repo

	if repo == "" or not repo then
		return ""
	end

	-- if cache file exists, print it and return
	local cache_dir = vim.fn.stdpath("cache")
	local heatmap_cache = cache_dir .. "/git-dashboard-nvim/gh-heatmap-" .. repo:gsub("/", "-") .. ".txt"
	local heatmap_cache_file_handle = io.open(heatmap_cache, "r")

	if heatmap_cache_file_handle and should_cache then
		-- if last modified date is 10 minutes ago, then refresh cache
		local last_modified = vim.fn.getftime(heatmap_cache)

		if os.difftime(os.time(), last_modified) < cache_time then
			local ascii_heatmap = heatmap_cache_file_handle:read("*a")
			heatmap_cache_file_handle:close()

			return ascii_heatmap
		end
	end

	-- todo: dates are in UTC, need to convert to local time
	local commits = GitHubAPI.get_commit_dates(author, branch)

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

	if show_repo_name then
		ascii_heatmap = ascii_heatmap .. repo .. "\n\n"
	end

	if #gap == 1 then
		for i = 1, current_month do
			ascii_heatmap = ascii_heatmap .. "   " .. gap .. months[i] .. " "
		end
		ascii_heatmap = ascii_heatmap .. "   " .. gap

		-- if last week of the month add extra spacing
		if #heatmap < weeks_in_year then
			ascii_heatmap = ascii_heatmap .. "  "
		end
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

	-- create cache file for repo heatmap
	if should_cache then
		local directory_exists = vim.fn.isdirectory(cache_dir .. "/git-dashboard-nvim")

		if directory_exists == 0 then
			vim.fn.mkdir(cache_dir .. "/git-dashboard-nvim")
		end

		heatmap_cache_file_handle = io.open(heatmap_cache, "w+")

		if heatmap_cache_file_handle then
			heatmap_cache_file_handle:write(ascii_heatmap)
			heatmap_cache_file_handle:close()
		end
	end

	return ascii_heatmap
end

return main
