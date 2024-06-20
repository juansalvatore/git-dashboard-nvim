local config = require("git-dashboard-nvim.config")

---@diagnostic disable-next-line: undefined-field
local eq = assert.are.same

local date_info = {
  current_day_of_week = 4,
  current_month = "06",
  current_week = 24,
  days_in_week = 7,
  weeks_in_year = 52,
}

describe("heatmap", function()
  it("create base heatmap", function()
    local heatmap = require("git-dashboard-nvim.heatmap.utils")
    local dates = {
      -- 5 commits
      { day = 2, day_of_week = 0, month = 6, week = 22, year = 2024 },
      { day = 2, day_of_week = 0, month = 6, week = 22, year = 2024 },
      { day = 2, day_of_week = 0, month = 6, week = 22, year = 2024 },
      { day = 2, day_of_week = 0, month = 6, week = 22, year = 2024 },
      { day = 2, day_of_week = 0, month = 6, week = 22, year = 2024 },

      -- 1 commit
      { day = 1, day_of_week = 6, month = 6, week = 21, year = 2024 },

      -- 3 commits
      { day = 29, day_of_week = 3, month = 5, week = 21, year = 2024 },
      { day = 29, day_of_week = 3, month = 5, week = 21, year = 2024 },
      { day = 29, day_of_week = 3, month = 5, week = 21, year = 2024 },
      { day = 29, day_of_week = 3, month = 5, week = 21, year = 2024 },
      { day = 29, day_of_week = 3, month = 5, week = 21, year = 2024 },
    }

    local ascii_heatmap = heatmap.generate_base_heatmap(dates, date_info)

    eq(ascii_heatmap, {
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 5, 0, 0, 1 },
      { 5, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
    })
  end)

  it("create ascii heatmap", function()
    local heatmap = require("git-dashboard-nvim.heatmap.utils")
    local base_heatmap = {
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 5, 0, 0, 1 },
      { 5, 0, 0, 0, 0, 0, 0 },
    }

    local config_defaults = config.get_config_defaults()

    local repo_with_owner = "owner/repo"

    local ascii_heatmap =
      heatmap.generate_ascii_heatmap(base_heatmap, config_defaults, repo_with_owner, date_info)

    eq(
      ascii_heatmap,
      [[repo

     Jan     Feb     Mar     Apr     May     Jun 
Sun □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ ■ 
Mon □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ 
Tue □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ 
Wed □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ ■ □ 
Thu □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ 
Fri □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ 
Sat □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ □ ■ □ 

 main
]]
    )
  end)
end)
