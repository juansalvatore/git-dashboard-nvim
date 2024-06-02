M = {}

M.create_cache = function(repo, should_cache, cache_time)
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
end

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
