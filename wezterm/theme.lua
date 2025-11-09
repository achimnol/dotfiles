local wezterm = require("wezterm")
local M = {}

---@type Mode|nil
local force = nil

---@enum (key) Mode
local theme = {
  light = "rose-pine-dawn",
  dark = "rose-pine",
}

---@return Mode
local detect = function()
  if force ~= nil then
    return force
  elseif wezterm.gui and wezterm.gui.get_appearance():find("Light") then
    return "light"
  end
  return "dark"
end

M.set = function(config)
  local mode = detect()
  config.color_scheme = theme[mode]

  local ok, _, stderr = wezterm.run_child_process({
    "sh",
    "-c",
    'echo "' .. mode .. '" > /tmp/wezterm-theme',
  })
  if not ok then
    error(stderr, 0)
  end
end

return M
