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

  local branch_label = config.branch
  if vim.g.have_nerd_font == true then
    branch_label = " " .. config.branch
  end

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

  -- horizontal heatmap
  if config.is_horizontal then
    -- add month labels
    if #config.gap == 1 then
      ascii_heatmap = ascii_heatmap .. " "
      for i = 1, current_date_info.current_month do
        ascii_heatmap = ascii_heatmap .. "   " .. config.gap .. config.months[i] .. " "
      end

      ascii_heatmap = ascii_heatmap .. "\n"
    else
      ascii_heatmap = ascii_heatmap .. "\n"
    end

    -- add day labels and generate heatmap
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
  else
    -- generate vertical heatmap instead of horizontal
    for _i = 1, #base_heatmap do
      local i = #base_heatmap - _i + 1 -- reverse the order
      local row = base_heatmap[i]
      local sum = 0
      for _, value in ipairs(row) do
        sum = sum + value
      end

      for j = 1, current_date_info.days_in_week do
        if
          i == tonumber(current_date_info.current_week)
          and j > tonumber(current_date_info.current_day_of_week) + 1
        then
          ascii_heatmap = ascii_heatmap .. config.empty .. config.gap
        elseif base_heatmap[i][j] > 0 then
          ascii_heatmap = ascii_heatmap .. config.filled_square .. config.gap -- filled square
        else
          if sum ~= 0 then
            ascii_heatmap = ascii_heatmap .. config.empty_square .. config.gap
          end
        end
      end

      -- if no commits in the heatmap row, then skip
      if sum ~= 0 then
        local sum_str = tostring(sum)

        if config.show_contributions_count == true then
          -- add padding to the sum string to align the heatmap (works up to 999 commits)
          if sum < 10 then
            sum_str = sum_str .. "  "
          elseif sum < 100 then
            sum_str = sum_str .. " "
          end

          ascii_heatmap = ascii_heatmap .. " " .. sum_str .. " "
        end
        ascii_heatmap = ascii_heatmap .. "\n"
      end
    end
  end

  if config.show_current_branch then
    ascii_heatmap = ascii_heatmap .. "\n" .. branch_label .. "\n"
  end

  return ascii_heatmap
end

return HeatmapUtils
