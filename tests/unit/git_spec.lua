describe("git", function()
  it("should be able to require git", function()
    local git = require("git-dashboard-nvim.git")
    assert(git ~= nil)
  end)

  it("should return current branch", function()
    local git = require("git-dashboard-nvim.git")
    local current_branch = git.get_current_branch()

    assert(current_branch ~= nil)
  end)

  it("should return repo with owner", function()
    local git = require("git-dashboard-nvim.git")
    local repo_with_owner = git.get_repo_with_owner()

    assert(repo_with_owner ~= nil)
    assert(repo_with_owner == "juansalvatore/git-dashboard-nvim")
  end)

  it("should parse repo with owner from bitbucket ssh url", function()
    local git = require("git-dashboard-nvim.git")
    local repo_with_owner =
      git._parse_repo_and_owner("git@bitbucket.org:juansalvatore/git-dashboard-nvim.git")

    assert(repo_with_owner ~= nil)
    assert(repo_with_owner == "juansalvatore/git-dashboard-nvim")
  end)

  it("should parse repo with owner from github ssh url", function()
    local git = require("git-dashboard-nvim.git")
    local repo_with_owner =
      git._parse_repo_and_owner("git@github.com:juansalvatore/git-dashboard-nvim.git")

    assert(repo_with_owner ~= nil)
    assert(repo_with_owner == "juansalvatore/git-dashboard-nvim")
  end)

  it("should parse repo with owner from github ssh url without .git", function()
    local git = require("git-dashboard-nvim.git")
    local repo_with_owner =
      git._parse_repo_and_owner("git@github.com:juansalvatore/git-dashboard-nvim")

    assert(repo_with_owner ~= nil)
    assert(repo_with_owner == "juansalvatore/git-dashboard-nvim")
  end)

  it("should parse repo with owner from github https url", function()
    local git = require("git-dashboard-nvim.git")
    local repo_with_owner =
      git._parse_repo_and_owner("https://github.com/juansalvatore/git-dashboard-nvim.git")

    assert(repo_with_owner ~= nil)
    assert(repo_with_owner == "juansalvatore/git-dashboard-nvim")
  end)

  it("should parse repo with owner from github https url without .git", function()
    local git = require("git-dashboard-nvim.git")
    local repo_with_owner =
      git._parse_repo_and_owner("https://github.com/juansalvatore/git-dashboard-nvim")

    assert(repo_with_owner ~= nil)
    assert(repo_with_owner == "juansalvatore/git-dashboard-nvim")
  end)

  it("should return commit dates", function()
    local git = require("git-dashboard-nvim.git")
    local commits = git.get_commit_dates("username", "main")

    assert(commits ~= nil)
  end)
end)
