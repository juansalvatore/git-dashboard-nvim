GitHubAPI = {}

GitHubAPI.is_gh_installed = function()
	return vim.fn.systemlist("gh 2>/dev/null")[1] ~= nil
end

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

GitHubAPI.get_commit_dates = function(repo, emailOrName)
	local commits = {}

	local username = "Juan Salvatore"
	-- Execute git command
	local git_command = string.format(
		'git log main --author="%s" --since="2024-01-01" --date=format:"%%Y-%%m-%%dT%%H:%%M:%%SZ" --pretty=format:"%%ad"',
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

-- check if gh is installed
if not GitHubAPI.is_gh_installed() then
	print("GitHub CLI is not installed. Please install it to use this plugin.")
	return
end

return GitHubAPI
