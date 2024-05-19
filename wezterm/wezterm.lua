local wezterm = require 'wezterm';
-- local _font_features = { "calt", "ss13" }
local _font_features = { }

local scheme, metadata = wezterm.color.load_scheme("/Users/joongi/.config/wezterm/my-github-dark.toml")
-- local scheme = wezterm.get_builtin_color_schemes()['GitHub Dark']
-- scheme.foreground = '#c0c7d5'
-- wezterm.color.save_scheme(scheme, { author = 'Joongi Kim', name = 'My GitHub Dark' }, '/tmp/my-github-dark.toml')

return {
    use_ime = true,
    -- color_scheme = "Catppuccin Mocha",
    -- front_end = "WebGpu",
    color_schemes = {
        ['My GitHub Dark'] = scheme,
    },
    color_scheme = "My GitHub Dark",
    window_decorations = "RESIZE",
    native_macos_fullscreen_mode = false,
    font_rules = {
        {
            intensity = 'Normal',
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Regular", harfbuzz_features = _font_features },
                "JetBrains Mono",
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Regular" },
                { family = "Pretendard", weight = "Regular" },
            }),
        },
        {
            intensity = 'Normal',
            italic = true,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Regular", style = "Oblique", harfbuzz_features = _font_features },
                "JetBrains Mono",
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Regular", style = "Oblique" },
                { family = "Pretendard", weight = "Regular", style = "Oblique" },
            }),
        },
        {
            intensity = 'Half',
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Light", harfbuzz_features = _font_features },
                "JetBrains Mono",
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Light" },
                { family = "Pretendard", weight = "Light" },
            }),
        },
        {
            intensity = 'Half',
            italic = true,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Light", style = "Oblique", harfbuzz_features = _font_features },
                "JetBrains Mono",
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Light", style = "Oblique" },
                { family = "Pretendard", weight = "Light", style = "Oblique" },
            }),
        },
        {
            intensity = 'Bold',
            italic = false,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Bold", harfbuzz_features = _font_features },
                { family = "JetBrains Mono", weight = "Bold" },
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Bold" },
                { family = "Pretendard", weight = "Bold" },
            }),
        },
        {
            intensity = 'Bold',
            italic = true,
            font = wezterm.font_with_fallback({
                { family = "PragmataPro", weight = "Bold", style = "Oblique", harfbuzz_features = _font_features },
                { family = "JetBrains Mono", weight = "Bold", style = "Oblique" },
                -- { family = "Apple SD 산돌고딕 Neo", weight = "Bold", style = "Oblique" },
                { family = "Pretendard", weight = "Bold", style = "Oblique" },
            }),
        },
    },
    font_size = 14.0,
    cell_width = 0.82,  -- PragmataPro adjustment
    line_height = 0.84, -- PragmataPro adjustment
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
