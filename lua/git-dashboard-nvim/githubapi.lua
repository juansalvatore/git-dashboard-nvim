GitHubAPI = {}

GitHubAPI.get_repo_with_owner = function()
	local handle = io.popen("git remote get-url origin 2>/dev/null")
	if not handle then
		return ""
	end

	local remote_url = handle:read("*a")
	handle:close()

	if remote_url and remote_url ~= "" then
		remote_url = remote_url:gsub("%s+", "") -- Remove any trailing newlines or spaces

		local name_with_owner = remote_url:match("github%.com[:/]([^/]+/[^/.]+)%.git")
			or remote_url:match("github%.com[:/]([^/]+/[^/.]+)")
		if name_with_owner then
			return name_with_owner
		end
	end

	return ""
end

local function parse_date(date)
	local year, month, day = date:match("(%d+)-(%d+)-(%d+)")
	local week = os.date("%U", os.time({ year = year, month = month, day = day }))
	local day_of_week = os.date("%w", os.time({ year = year, month = month, day = day }))

	return {
		year = tonumber(year),
		month = tonumber(month),
		day = tonumber(day),
		week = tonumber(week),
		day_of_week = tonumber(day_of_week),
	}
end

GitHubAPI.get_commit_dates = function(username, branch)
	local commits = {}

	local current_year = tostring(os.date("%Y"))

	local since_date = os.date("%Y-%m-%d", os.time({ year = current_year, month = 1, day = 1 }))

	local git_command = string.format(
		"git log "
			.. branch
			.. ' --author="%s" --since="'
			.. since_date
			.. '" --date=format:"%%Y-%%m-%%dT%%H:%%M:%%SZ" --pretty=format:"%%ad"',
		username
	)

	local handle = io.popen(git_command)

	if not handle then
		return commits
	end

	-- Read output line by line and parse date
	for line in handle:lines() do
		local date = parse_date(line)
		table.insert(commits, date)
	end

	handle:close()

	return commits
end

return GitHubAPI
