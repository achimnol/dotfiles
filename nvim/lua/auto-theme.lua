local M = {}

---@enum (key) Mode
local theme = {
  light = "rose-pine-dawn",
  dark = "rose-pine",
}

---@param callback fun(mode: Mode)
local detect = function(callback)
  vim.system(
    {
      "cat",
      "/tmp/wezterm-theme",
    },
    { text = true },
    ---@param obj vim.SystemCompleted
    vim.schedule_wrap(function(obj)
      callback(vim.trim(obj.stdout))
    end)
  )
end

M.update = function()
  detect(function(mode)
    vim.cmd.colorscheme(theme[mode])
  end)
end

return M
