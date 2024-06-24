Utils = {}

Utils.create_dashboard_update_on_shell_cmd = function()
  -- create an autocommand on BufWritePost when a command is ran using :! to call the dashboard redraw from require('dashboard')
  vim.api.nvim_create_autocmd({ "ShellCmdPost" }, {
    callback = function()
      -- for users who have dashboard-nvim installed
      if package.loaded.dashboard ~= nil then
        if vim.bo.filetype ~= "dashboard" then
          return
        end

        vim.cmd("silent! Lazy reload dashboard-nvim")

        vim.bo.modifiable = true
        vim.cmd("silent! %d")
        vim.cmd("silent! Dashboard")
        vim.bo.modifiable = false
      end
    end,
  })
end

---@param date string
---@return {year: number, month: number, day: number, week: number, day_of_week: number}
Utils.parse_date = function(date)
  local year, month, day = date:match("(%d+)-(%d+)-(%d+)")
  local week = os.date("%U", os.time({ year = year, month = month, day = day }))
  local day_of_week = os.date("%w", os.time({ year = year, month = month, day = day }))

  return {
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    week = tonumber(week),
    day_of_week = tonumber(day_of_week),
  }
end

---@return {current_month: string, current_week: number, current_day_of_week: number, days_in_week: number, weeks_in_year: number}
Utils.current_date_info = function()
  return {
    current_month = os.date("%m"),
    current_week = tonumber(os.date("%U")),
    current_day_of_week = tonumber(os.date("%w")),
    days_in_week = 7,
    weeks_in_year = 52,
  }
end

Utils.trim = function(str)
  return str:gsub("^%s+", ""):gsub("%s+$", "")
end

return Utils
