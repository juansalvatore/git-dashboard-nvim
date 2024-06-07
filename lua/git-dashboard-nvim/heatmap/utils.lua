local utils = require("git-dashboard-nvim.utils")

M = {}

M.generate_base_heatmap = function(dates)
  local heatmap = {}
  local date_info = utils.current_date_info()

  -- create base heatmap
  for i = 1, date_info.weeks_in_year do
    heatmap[i] = {}

    for j = 1, date_info.days_in_week do
      heatmap[i][j] = 0
    end

    if i == date_info.current_week then
      break
    end
  end

  for _, date in ipairs(dates) do
    -- if commit date is in the future or before January 1st of current year, then skip
    local week = date.week
    local day_of_week = date.day_of_week + 1

    if not heatmap[week] then
      heatmap[week] = {}
    end

    if not heatmap[week][day_of_week] then
      heatmap[week][day_of_week] = 0
    end

    heatmap[week][day_of_week] = heatmap[week][day_of_week] + 1
  end

  return heatmap
end

---@param base_heatmap number[][]
---@param config Config
---@param repo_with_owner string
---@return string
M.generate_ascii_heatmap = function(base_heatmap, config, repo_with_owner)
  local date_info = utils.current_date_info()
  local ascii_heatmap = ""

  local title = ""
  if config.title == "owner_with_repo_name" then
    title = repo_with_owner
    ascii_heatmap = ascii_heatmap .. title .. "\n\n"
  elseif config.title == "repo_name" then
    -- extract repo name from owner/repo
    local repo_name = repo_with_owner:match("([^/]+)$")
    title = repo_name
    ascii_heatmap = ascii_heatmap .. title .. "\n\n"
  else
    ascii_heatmap = ascii_heatmap .. "\n\n"
  end

  vim.cmd('call matchadd("DashboardTitle", "' .. title .. '")')

  if #config.gap == 1 then
    ascii_heatmap = ascii_heatmap .. " "
    for i = 1, date_info.current_month do
      ascii_heatmap = ascii_heatmap .. "   " .. config.gap .. config.months[i] .. " "
    end

    -- ascii_heatmap = ascii_heatmap .. "ooo" .. gap

    -- if last week of the month add extra spacing
    -- if #heatmap < weeks_in_year then
    -- 	ascii_heatmap = ascii_heatmap .. "EE"
    -- end
    ascii_heatmap = ascii_heatmap .. "\n"
  else
    ascii_heatmap = ascii_heatmap .. "\n"
  end

  -- Clear existing matches
  vim.cmd("match none")

  vim.cmd("highlight clear DashboardHeader")

  for i = 1, date_info.days_in_week do
    local highlight_group = "DayHighlight" .. i
    ascii_heatmap = ascii_heatmap .. config.days[i] .. config.day_label_gap
    vim.cmd('call matchadd("' .. highlight_group .. '", "' .. config.days[i] .. '")')

    for j = 1, #base_heatmap do
      if
        j == tonumber(date_info.current_week) and i > tonumber(date_info.current_day_of_week) + 1
      then
        highlight_group = "EmptySquareHighlight"
        vim.cmd("call matchadd('" .. highlight_group .. "', '" .. config.empty_square .. "')")
        ascii_heatmap = ascii_heatmap .. config.empty .. config.gap
      elseif base_heatmap[j][i] > 0 then
        highlight_group = "FilledSquareHighlight"
        vim.cmd("call matchadd('" .. highlight_group .. "', '" .. config.filled_square .. "')")
        ascii_heatmap = ascii_heatmap .. config.filled_square .. config.gap
      else
        highlight_group = "EmptySquareHighlight"
        vim.cmd("call matchadd('" .. highlight_group .. "', '" .. config.empty_square .. "')")
        ascii_heatmap = ascii_heatmap .. config.empty_square .. config.gap
      end
    end

    ascii_heatmap = ascii_heatmap .. "\n"
  end

  if config.show_current_branch then
    local highlight_group = "BranchHighlight"
    local branch_label = " " .. config.branch
    ascii_heatmap = ascii_heatmap .. "\n" .. branch_label .. "\n"
    vim.cmd('call matchadd("' .. highlight_group .. '",' .. '"' .. branch_label .. '")')
  end

  -- only affect the dashboard buffer with highlights
  vim.cmd("highlight DashboardHeader guifg=#7eac6f")
  vim.cmd("highlight EmptySquareHighlight guifg=#54734a")
  vim.cmd("highlight FilledSquareHighlight guifg=#AFD2A3")
  vim.cmd("highlight BranchHighlight guifg=#8DC07C")
  vim.cmd("highlight DashboardTitle guifg=#a3cc96")

  return ascii_heatmap
end

return M
