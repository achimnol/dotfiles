local wezterm = require("wezterm")
local M = {}

---@type Mode|nil
local force = nil

---@enum (key) Mode
local rose_pine = require('rose-pine-custom')

local theme = {
  light = rose_pine.dawn,
  dark = rose_pine.main,
  -- (intrinsic themes)
  -- light = "rose-pine-dawn",
  -- dark = "rose-pine",
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
  config.colors = theme[mode].colors()
  config.window_frame = theme[mode].window_frame()

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
