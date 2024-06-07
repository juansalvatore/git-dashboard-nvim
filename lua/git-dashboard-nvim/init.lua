local utils = require("git-dashboard-nvim.utils")
local heatmap = require("git-dashboard-nvim.heatmap")
local config_utils = require("git-dashboard-nvim.config")

M = {}

---@param config Config
M.setup = function(config)
  config = config_utils.set_config_defaults(config)

  local ascii_heatmap = heatmap.generate_heatmap(config)

  if ascii_heatmap == "" then
    if config.fallback_header ~= "" then
      ascii_heatmap = config.fallback_header
    else
      ascii_heatmap = string.rep("\n", 10)
    end
  end

  utils.create_dashboard_update_on_shell_cmd()

  return vim.split(
    string.rep("\n", config.top_padding) .. ascii_heatmap .. string.rep("\n", config.bottom_padding),
    "\n"
  )
end

return M
