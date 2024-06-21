local Highlights = require("git-dashboard-nvim.highlights")

HeatmapUtils = {}

---@param dates table
---@param current_date_info table
---@return number[][]
HeatmapUtils.generate_base_heatmap = function(dates, current_date_info)
  local heatmap = {}

  -- create base heatmap
  for i = 1, current_date_info.weeks_in_year do
    heatmap[i] = {}

    for j = 1, current_date_info.days_in_week do
      heatmap[i][j] = 0
    end

    if i == current_date_info.current_week then
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
HeatmapUtils.generate_ascii_heatmap = function(
  base_heatmap,
  config,
  repo_with_owner,
  current_date_info
)
  local ascii_heatmap = ""
  local branch_label = " " .. config.branch

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

  -- add highlights to the heatmap based on the config settings
  Highlights.add_highlights(config, current_date_info, branch_label, title)

  if #config.gap == 1 then
    ascii_heatmap = ascii_heatmap .. " "
    for i = 1, current_date_info.current_month do
      ascii_heatmap = ascii_heatmap .. "   " .. config.gap .. config.months[i] .. " "
    end

    ascii_heatmap = ascii_heatmap .. "\n"
  else
    ascii_heatmap = ascii_heatmap .. "\n"
  end

  for i = 1, current_date_info.days_in_week do
    ascii_heatmap = ascii_heatmap .. config.days[i] .. config.day_label_gap

    for j = 1, #base_heatmap do
      if
        j == tonumber(current_date_info.current_week)
        and i > tonumber(current_date_info.current_day_of_week) + 1
      then
        ascii_heatmap = ascii_heatmap .. config.empty .. config.gap
      elseif base_heatmap[j][i] > 0 then
        ascii_heatmap = ascii_heatmap .. config.filled_square .. config.gap
      else
        ascii_heatmap = ascii_heatmap .. config.empty_square .. config.gap
      end
    end

    ascii_heatmap = ascii_heatmap .. "\n"
  end

  if config.show_current_branch then
    ascii_heatmap = ascii_heatmap .. "\n" .. branch_label .. "\n"
  end

  return ascii_heatmap
end

return HeatmapUtils
