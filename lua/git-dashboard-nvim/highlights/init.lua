Highlights = {}

---@param group_name string
---@param match string
---@param fg_color string
Highlights._add_highlight_group = function(group_name, match, fg_color)
  vim.cmd("highlight " .. group_name .. " guifg=" .. fg_color)
  vim.cmd('call matchadd("' .. group_name .. '", "' .. match .. '")')
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

  -- Add highlights for DashboardHeader section
  Highlights._add_highlight_group(
    "DashboardHeaderEmptySquare",
    config.empty_square,
    config.colors.empty_square_highlight
  )

  for i = 1, #config.days do
    Highlights._add_highlight_group(
      "DashboardHeaderDay" .. i,
      config.days[i]:sub(1, 3),
      config.colors.days_and_months_labels
    )
  end

  for i = 1, current_date_info.current_month do
    Highlights._add_highlight_group(
      "DashboardHeaderMonth" .. i,
      config.months[i]:sub(1, 3),
      config.colors.days_and_months_labels
    )
  end

  for i = 1, #config.filled_squares do
    Highlights._add_highlight_group(
      "DashboardHeaderFilledSquare" .. i,
      config.filled_squares[i],
      config.colors.filled_square_highlights[i]
    )
  end

  -- add highlight to match any number
  vim.cmd("call matchadd('DashboardHeaderMonthHighlight', '\\d\\+')")

  Highlights._add_highlight_group("DashboardHeaderTitle", title, config.colors.dashboard_title)

  Highlights._add_highlight_group(
    "DashboardHeaderBranch",
    branch_label,
    config.colors.branch_highlight
  )

  -- set cursor color to white when leaving the buffer
  vim.cmd.autocmd("BufLeave", "*", "highlight Cursor blend=0")
  vim.cmd.autocmd("BufLeave", "*", "set guicursor+=a:Cursor/lCursor")
end

return Highlights
