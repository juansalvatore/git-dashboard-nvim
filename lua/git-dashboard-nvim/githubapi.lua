GitHubAPI = {}

-- check if gh is installed
GitHubAPI.is_gh_installed = function()
	return vim.fn.systemlist("gh 2>/dev/null")[1] ~= nil
end

GitHubAPI.get_repo_with_owner = function()
	local get_repo_command = "gh repo view --json nameWithOwner --jq '.nameWithOwner' 2>/dev/null"
	local repo = vim.fn.systemlist(get_repo_command)[1]

	return repo
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

	-- if commits is {} then return nil
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
