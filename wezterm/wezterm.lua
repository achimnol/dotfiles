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
    font_rules = {
        {
            intensity = 'Normal',
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Medium", harfbuzz_features = _font_features },
                -- "JetBrains Mono",
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Regular" },
                { family = "Pretendard", weight = "Medium" },
            }),
        },
        {
            intensity = 'Normal',
            italic = true,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Medium", style = "Oblique", harfbuzz_features = _font_features },
                -- "JetBrains Mono",
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Regular", style = "Oblique" },
                { family = "Pretendard", weight = "Medium", style = "Oblique" },
            }),
        },
        {
            intensity = 'Half',
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Light", harfbuzz_features = _font_features },
                -- "JetBrains Mono",
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Light" },
                { family = "Pretendard", weight = "Light" },
            }),
        },
        {
            intensity = 'Half',
            italic = true,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Light", style = "Oblique", harfbuzz_features = _font_features },
                -- "JetBrains Mono",
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Light", style = "Oblique" },
                { family = "Pretendard", weight = "Light", style = "Oblique" },
            }),
        },
        {
            intensity = 'Bold',
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Bold", harfbuzz_features = _font_features },
                -- { family = "JetBrains Mono", weight = "Bold" },
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Bold" },
                { family = "Pretendard", weight = "Bold" },
            }),
        },
        {
            intensity = 'Bold',
            italic = true,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Bold", style = "Oblique", harfbuzz_features = _font_features },
                -- { family = "JetBrains Mono", weight = "Bold", style = "Oblique" },
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Bold", style = "Oblique" },
                { family = "Pretendard", weight = "Bold", style = "Oblique" },
            }),
        },
    },
    font_size = 14.0,
    cell_width = 0.82,  -- PragmataPro adjustment
    line_height = 0.83, -- PragmataPro adjustment
    freetype_render_target = 'Normal',
    freetype_load_target = 'HorizontalLcd',
    -- freetype_load_flags = 'NO_HINTING',
    -- freetype_load_target = 'Normal',
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
    },
    -- debug_key_events = true,
}

-- Automatic switching for dark/light themes
require("theme").set(config)

return config
