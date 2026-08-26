local wezterm = require 'wezterm';
local _font_features = { }

local config = {
    mux_enable_ssh_agent = false,
    use_ime = true,
    -- color_scheme = "Rosé Pine (Gogh)",
    -- color_scheme = "Rosé Pine Dawn (Gogh)",
    -- front_end = "WebGpu",
    window_decorations = "RESIZE",
    window_padding = {
      left = 3,
      right = 3,
      top = 2,
      bottom = 2,
    },
    -- window_background_opacity = 0.92,
    -- text_background_opacity = 0.8,
    -- macos_window_background_blur = 40,
    native_macos_fullscreen_mode = false,
    font = wezterm.font_with_fallback { "PragmataPro Mono", "Sarasa Term K" },
    font_size = 14.0,
    -- freetype_render_target = 'Normal',
    -- freetype_load_target = 'Light',
    -- freetype_load_flags = 'NO_HINTING',
    unicode_version = 14,
    -- allow_square_glyphs_to_overflow_width = 'Never',
    -- treat_east_asian_ambiguous_width_as_wide = false,
    -- cell_widths = {
    --   { first = 0xe000, last = 0xf8ff, width = 2 },
    --   { first = 0xf0000, last = 0xf1fff, width = 2 },
    --   { first = 0x2014, last = 0x2015, width = 2 },  -- em-dash, horiz-bar
    --   { first = 0x2190, last = 0x21ff, width = 2 },  -- Arrows
    -- },
    normalize_output_to_unicode_nfc = false,
    custom_block_glyphs = false,
    -- colors = { compose_cursor = "orange" },
    keys = {
      {key="LeftArrow", mods="SUPER", action=wezterm.action{ActivateTabRelative=-1}},
      {key="RightArrow", mods="SUPER", action=wezterm.action{ActivateTabRelative=1}},
      {key="Tab", mods="CTRL|SHIFT", action=wezterm.action{ActivateTabRelative=-1}},
      {key="Tab", mods="CTRL", action=wezterm.action{ActivateTabRelative=1}},
      {key="UpArrow", mods="SUPER", action=wezterm.action{SendString="\x1b[5~"}},   -- PageUp
      {key="DownArrow", mods="SUPER", action=wezterm.action{SendString="\x1b[6~"}}, -- PageDown
      {key="f", mods="SHIFT|SUPER", action="ToggleFullScreen"},
      {key="q", mods="CTRL", action=wezterm.action{ SendString="\x11" } },  -- wez/wezterm#2630
      {key="Enter", mods="SHIFT", action=wezterm.action{ SendString="\x1b[13;2u" } },  -- Shift+Enter for Claude Code
    },
    -- debug_key_events = true,
}

-- Automatic switching for dark/light themes
require("theme").set(config)

return config
