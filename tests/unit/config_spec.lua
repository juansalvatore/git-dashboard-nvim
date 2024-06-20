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
    })
  end)
end)
