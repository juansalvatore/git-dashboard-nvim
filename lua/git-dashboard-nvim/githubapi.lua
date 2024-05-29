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

GitHubAPI.get_commit_dates = function(repo, emailOrName)
	-- todo: only get commits from the last year
	local get_commits_command = string.format(
		'gh api -X GET "repos/%s/commits" --paginate --jq ".[] | select(.commit.author.email == \\"%s\\" or .commit.author.name == \\"%s\\") | .commit.author.date" 2>/dev/null',
		repo,
		emailOrName,
		emailOrName
	)

	local commits = vim.fn.systemlist(get_commits_command)

	if commits[1] == "{}" then
		return nil
	end

	return commits
end

-- check if gh is installed
if not GitHubAPI.is_gh_installed() then
	print("GitHub CLI is not installed. Please install it to use this plugin.")
	return
end

return GitHubAPI
