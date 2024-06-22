Highlights = {}

---@param group_name string
---@param match string
---@param fg_color string
Highlights._add_highlight_group = function(group_name, match, fg_color)
  vim.cmd("highlight " .. group_name .. " guifg=" .. fg_color)
  vim.cmd('call matchadd("' .. group_name .. '", "' .. match .. '")')
  -- only apply highlights to the buffer "dashboard", so that it doesn't affect other buffers
end

---@param config Config
---@param current_date_info table
---@param branch_label string
---@param title string
Highlights.add_highlights = function(config, current_date_info, branch_label, title)
  -- Clear existing matches
  vim.cmd("match none")

  -- clear dashboard header existing highlights
  vim.cmd("highlight clear DashboardHeader")

  Highlights._add_highlight_group(
    "EmptySquareHighlight",
    config.empty_square,
    config.colors.empty_square_highlight
  )

  for i = 1, #config.days do
    Highlights._add_highlight_group(
      "DayHighlight",
      config.days[i]:sub(1, 3),
      config.colors.days_and_months_labels
    )
  end

  for i = 1, current_date_info.current_month do
    Highlights._add_highlight_group(
      "MonthHighlight",
      config.months[i]:sub(1, 3),
      config.colors.days_and_months_labels
    )
  end

  for i = 1, #config.filled_squares do
    Highlights._add_highlight_group(
      "FilledSquareHighlight" .. i,
      config.filled_squares[i],
      config.colors.filled_square_highlights[i]
    )
  end

  -- add highlight to match any number
  vim.cmd("call matchadd('MonthHighlight', '\\d\\+')")

  Highlights._add_highlight_group("DashboardTitle", title, config.colors.dashboard_title)

  Highlights._add_highlight_group("BranchHighlight", branch_label, config.colors.branch_highlight)

  vim.cmd.autocmd(
    "BufLeave",
    "*",
    "highlight clear DashboardHeader | highlight clear EmptySquareHighlight | highlight clear FilledSquareHighlight | highlight clear BranchHighlight | highlight clear DashboardTitle | highlight clear DayHighlight | highlight clear MonthHighlight"
  )
end

return Highlights
