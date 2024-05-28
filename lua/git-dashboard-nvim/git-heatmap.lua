local _name = "Juan Salvatore"

-- check if gh is installed
if not GitHubAPI.is_gh_installed() then
	print("GitHub CLI is not installed. Please install it to use this plugin.")
	return
end

-- get repo with owner and commits
local repo = GitHubAPI.get_repo_with_owner() -- owner/repo

P(repo)

if not repo then
	print("No repository found.")
	return
end

-- if cache file exists, print it and return
local cache_dir = vim.fn.stdpath("cache")
local cache_file = cache_dir .. "/git-dashboard-nvim/gh-heatmap-" .. repo:gsub("/", "-") .. ".txt"
local log_file = cache_dir .. "/git-dashboard-nvim/gh-heatmap-" .. repo:gsub("/", "-") .. ".log"

local cache_file_handle = io.open(cache_file, "r")

if cache_file_handle then
	local cache_content = cache_file_handle:read("*a")
	cache_file_handle:close()

	print(cache_content)
	return
end

-- todo: dates are in UTC, need to convert to local time
local commits = GitHubAPI.get_commit_dates(repo, _name) -- { "2024-05-27T21:51:12Z" }

if not commits then
	print("No commits found.")
	return
end

local heatmap = {}

local weeks_in_year = 52
local days_in_week = 7

local current_week = os.date("%U")
local current_day_of_week = os.date("%w")

for i = 1, weeks_in_year do
	heatmap[i] = {}

	for j = 1, days_in_week do
		heatmap[i][j] = 0
	end

	if i == tonumber(current_week) then
		break
	end
end

local function get_week(date)
	local year, month, day = date:match("(%d+)-(%d+)-(%d+)")
	local week = os.date("%U", os.time({ year = year, month = month, day = day }))
	return tonumber(week)
end

local function get_day_of_week(date)
	local year, month, day = date:match("(%d+)-(%d+)-(%d+)")
	local day_of_week = os.date("%w", os.time({ year = year, month = month, day = day }))
	return tonumber(day_of_week)
end

for _, commit_date in ipairs(commits) do
	local date = commit_date
	local week = get_week(date)
	local day_of_week = get_day_of_week(date)
	heatmap[week][day_of_week] = heatmap[week][day_of_week] + 1
end

local ascii_heatmap = ""

local empty = " "
local empty_square = "□"
local filled_square = "■"
local show_repo_name = true
local gap = " "

local days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }

local months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
local current_month = os.date("%m")

if show_repo_name then
	ascii_heatmap = ascii_heatmap .. "\n" .. repo .. "\n\n"
end

-- add correct spacings based on month length to align with days
for i = 1, current_month do
	ascii_heatmap = ascii_heatmap .. "   " .. gap .. months[i] .. " "
end
ascii_heatmap = ascii_heatmap .. "   " .. gap

-- if last week of the month add extra spacing
if #heatmap < weeks_in_year then
	ascii_heatmap = ascii_heatmap .. "  "
end
ascii_heatmap = ascii_heatmap .. "\n"

for i = 1, days_in_week do
	ascii_heatmap = ascii_heatmap .. days[i] .. gap

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
local directory_exists = vim.fn.isdirectory(cache_dir .. "/git-dashboard-nvim")

if directory_exists == 0 then
	vim.fn.mkdir(cache_dir .. "/git-dashboard-nvim")
end

if cache_file_handle then
	cache_file_handle:write(ascii_heatmap)
	cache_file_handle:close()
end

-- log the timestamp of the last update of the heatmap
local log_file_handle = io.open(log_file, "w")

if log_file_handle then
	local date = os.date("%Y-%m-%d %H:%M:%S")
	if date then
		log_file_handle:write("Last updated: " .. date .. "\n")
		log_file_handle:close()
	end
end

print(ascii_heatmap)
