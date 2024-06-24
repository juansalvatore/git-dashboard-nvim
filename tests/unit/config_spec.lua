describe("config", function()
  ---@diagnostic disable-next-line: undefined-field
  local eq = assert.are.same

  it("should be able to require config", function()
    local config = require("git-dashboard-nvim.config")
    assert(config ~= nil)
  end)

  it("should return default config", function()
    local config = require("git-dashboard-nvim.config")
    local default_config = config.get_config_defaults()

    eq(default_config, {
      fallback_header = "",
      top_padding = 0,
      bottom_padding = 0,
      author = "",
      branch = "main",
      gap = " ",
      day_label_gap = " ",
      empty = " ",
      empty_square = "□",
      filled_squares = { "■", "■", "■", "■", "■", "■" },
      hide_cursor = true,
      centered = true,
      is_horizontal = true,
      show_contributions_count = true,
      show_only_weeks_with_commits = false,
      title = "repo_name",
      show_current_branch = true,
      days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" },
      months = {
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      },
      use_current_branch = true,
      colors = {
        days_and_months_labels = "#7eac6f",
        empty_square_highlight = "#54734a",
        filled_square_highlights = {
          "#2a3925",
          "#54734a",
          "#7eac6f",
          "#98c689",
          "#afd2a3",
          "#bad9b0",
        },
        branch_highlight = "#8DC07C",
        dashboard_title = "#a3cc96",
      },
    })
  end)

  it("should return config", function()
    local config = require("git-dashboard-nvim.config")
    local user_config = {
      fallback_header = "Git Dashboard",
      top_padding = 1,
      bottom_padding = 1,
      author = "John Doe",
      branch = "main",
      gap = " ",
      day_label_gap = " ",
      empty = " ",
      empty_square = "□",
      filled_square = "■",
      title = "repo_name",
      show_current_branch = true,
      days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" },
      months = {
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      },
      use_current_branch = true,
    }
    config = config.set_config_defaults(user_config)

    eq(config, {
      fallback_header = "Git Dashboard",
      top_padding = 1,
      bottom_padding = 1,
      author = "John Doe",
      branch = "main",
      gap = " ",
      day_label_gap = " ",
      empty = " ",
      empty_square = "□",
      filled_square = "■",
      title = "repo_name",
      show_current_branch = true,
      days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" },
      months = {
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      },
      use_current_branch = true,
      filled_squares = { "■", "■", "■", "■", "■", "■" },
      hide_cursor = true,
      centered = true,
      is_horizontal = true,
      show_contributions_count = true,
      show_only_weeks_with_commits = false,
      colors = {
        days_and_months_labels = "#7eac6f",
        empty_square_highlight = "#54734a",
        filled_square_highlights = {
          "#2a3925",
          "#54734a",
          "#7eac6f",
          "#98c689",
          "#afd2a3",
          "#bad9b0",
        },
        branch_highlight = "#8DC07C",
        dashboard_title = "#a3cc96",
      },
    })
  end)
end)
