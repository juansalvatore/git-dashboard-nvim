---@diagnostic disable-next-line: undefined-field
local eq = assert.are.same

describe("utils", function()
  it("should be able to require utils", function()
    local utils = require("git-dashboard-nvim.utils")
    assert(utils ~= nil)
  end)

  it("should parse date", function()
    local utils = require("git-dashboard-nvim.utils")
    local date = "2021-01-01"
    local parsed_date = utils.parse_date(date)

    eq(parsed_date, {
      year = 2021,
      month = 1,
      day = 1,
      week = 00,
      day_of_week = 5,
    })

    date = "2021-03-22"
    parsed_date = utils.parse_date(date)

    eq(parsed_date, {
      year = 2021,
      month = 3,
      day = 22,
      week = 12,
      day_of_week = 1,
    })
  end)

  it("should return current date info", function()
    local utils = require("git-dashboard-nvim.utils")
    local date_info = utils.current_date_info()

    eq(date_info, {
      current_month = os.date("%m"),
      current_week = tonumber(os.date("%U")),
      current_day_of_week = tonumber(os.date("%w")),
      days_in_week = 7,
      weeks_in_year = 52,
    })
  end)

  it("should create dashboard update on shell cmd", function()
    local utils = require("git-dashboard-nvim.utils")

    local autocommands = vim.api.nvim_get_autocmds({
      event = "ShellCmdPost",
    })

    eq(autocommands, {})

    utils.create_dashboard_update_on_shell_cmd()

    autocommands = vim.api.nvim_get_autocmds({
      event = "ShellCmdPost",
    })

    local result = {
      buflocal = false,
      callback = autocommands[1].callback, -- add function as we only care about the rest
      command = "",
      event = "ShellCmdPost",
      id = 12,
      once = false,
      pattern = "*",
    }

    eq(autocommands[1], result)

    -- cleanup
    vim.api.nvim_command("autocmd! ShellCmdPost")
  end)
end)
