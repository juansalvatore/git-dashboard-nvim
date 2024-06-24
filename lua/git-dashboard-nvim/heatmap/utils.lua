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
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "dashboard",
    callback = function()
      Highlights.add_highlights(config, current_date_info, branch_label, title)

      -- hide cursor
      if config.hide_cursor == true then
        vim.api.nvim_command("hi Cursor blend=100")
        vim.api.nvim_command("set guicursor+=a:Cursor/lCursor")
      end
    end,
  })

  -- horizontal heatmap
  if config.is_horizontal then
    -- add month labels
    if config.gap == " " and config.show_only_weeks_with_commits == false then
      ascii_heatmap = ascii_heatmap .. " "
      for i = 1, current_date_info.current_month do
        local month = config.months[i]:sub(1, 3)
        -- add padding so that the month is always 3 characters long
        for _ = 1, 3 - #month do
          month = month .. " "
        end
        ascii_heatmap = ascii_heatmap .. "   " .. config.gap .. month .. " "
      end

      ascii_heatmap = ascii_heatmap .. "\n"
    else
      ascii_heatmap = "\n" .. ascii_heatmap
    end

    -- add day labels and generate heatmap
    for i = 1, current_date_info.days_in_week do
      local day = config.days[i]:sub(1, 3)
      for _ = 1, 3 - #day do
        day = " " .. day
      end

      ascii_heatmap = ascii_heatmap .. day .. config.day_label_gap

      for j = 1, #base_heatmap do
        local row = base_heatmap[j]
        local sum = 0
        for _, value in ipairs(row) do
          sum = sum + value
        end

        if
          config.show_only_weeks_with_commits == false
          or config.show_only_weeks_with_commits == true and sum ~= 0
        then
          if
            j == tonumber(current_date_info.current_week)
            and i > tonumber(current_date_info.current_day_of_week) + 1
          then
            ascii_heatmap = ascii_heatmap .. config.empty .. config.gap
          elseif base_heatmap[j][i] > 0 then
            ascii_heatmap = ascii_heatmap
              .. config.filled_squares[base_heatmap[j][i] > 6 and 6 or base_heatmap[j][i]]
              .. config.gap
          else
            ascii_heatmap = ascii_heatmap .. config.empty_square .. config.gap
          end
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
          ascii_heatmap = ascii_heatmap
            .. config.filled_squares[base_heatmap[i][j] > 6 and 6 or base_heatmap[i][j]]
            .. config.gap
        else
          if sum ~= 0 or config.show_only_weeks_with_commits == false then
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
      elseif config.show_only_weeks_with_commits == false then
        ascii_heatmap = ascii_heatmap .. "    "
      end

      if sum ~= 0 or config.show_only_weeks_with_commits == false then
        ascii_heatmap = ascii_heatmap .. "\n"
      end
    end
  end

  if config.show_current_branch then
    ascii_heatmap = ascii_heatmap .. "\n" .. branch_label .. "\n"
  end

  -- center vertically ascii heatmap
  if config.centered then
    local lines = vim.api.nvim_get_option("lines")
    local ascii_heatmap_lines = vim.split(ascii_heatmap, "\n")
    local ascii_heatmap_lines_count = #ascii_heatmap_lines
    local padding = math.floor((lines - ascii_heatmap_lines_count) / 2)
    ascii_heatmap = string.rep("\n", padding) .. ascii_heatmap
  end

  return ascii_heatmap
end

return HeatmapUtils
