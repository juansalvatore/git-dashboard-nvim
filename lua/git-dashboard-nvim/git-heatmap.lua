local _email = "juansalvatore.ar@gmail.com"
local _name = "Juan Salvatore"

-- check if gh is installed
if not GitHubAPI.is_gh_installed() then
	print("GitHub CLI is not installed. Please install it to use this plugin.")
	return
end

-- get repo with owner and commits
local repo = GitHubAPI.get_repo_with_owner() -- owner/repo
local commits = GitHubAPI.get_commit_dates(repo, _name) -- { "2024-05-27T21:51:12Z" }

P(repo)
P(commits)
