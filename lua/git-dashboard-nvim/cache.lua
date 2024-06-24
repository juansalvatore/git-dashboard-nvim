--[[

  This file contains functions to create and write cache files for the heatmap
  of a repository. The cache file is created in the cache directory of the
  current neovim instance. The cache file is named as gh-heatmap-<repo>.txt
  where <repo> is the repository name with '/' replaced by '-'.

  The cache file is created only if the cache file does not exist or if the
  cache file is older than 10 minutes. The cache file is read if it exists and
  is not older than 10 minutes.

  This logic is not being used as with the current implementation of the git
  helpers the heatmap is created very fast and does not require caching.

]]
--

M = {}

---@param repo string
---@param should_cache boolean
---@param cache_time number
---@return string
M.create_cache = function(repo, should_cache, cache_time)
  -- if cache file exists, print it and return
  local cache_dir = vim.fn.stdpath("cache")
  local heatmap_cache = cache_dir
    .. "/git-dashboard-nvim/gh-heatmap-"
    .. repo:gsub("/", "-")
    .. ".txt"
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

  return ""
end

---@param ascii_heatmap string
---@param should_cache boolean
---@param cache_dir string
---@param heatmap_cache string
M.write_cache = function(ascii_heatmap, should_cache, cache_dir, heatmap_cache)
  -- create cache file for repo heatmap
  if should_cache then
    local directory_exists = vim.fn.isdirectory(cache_dir .. "/git-dashboard-nvim")

    if directory_exists == 0 then
      vim.fn.mkdir(cache_dir .. "/git-dashboard-nvim")
    end

    local heatmap_cache_file_handle = io.open(heatmap_cache, "w+")

    if heatmap_cache_file_handle then
      heatmap_cache_file_handle:write(ascii_heatmap)
      heatmap_cache_file_handle:close()
    end
  end
end
