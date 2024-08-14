local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Theme
local scheme = wezterm.color.get_builtin_schemes()['GruvboxDark']
scheme.foreground = '#c5c8c6'
scheme.cursor_bg = '#5fa624'
scheme.cursor_border = '#5fa624'
scheme.cursor_fg = '#1e1e1e'
config.colors = scheme

-- Fonts
config.font = wezterm.font({ family = 'FiraCode Nerd Font Mono', weight = 'Regular' })
config.font_size = 12
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.freetype_load_flags = 'NO_HINTING'

-- Window
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_frame = {
  font = wezterm.font({ family = 'FiraCode Nerd Font Mono', weight = 'Bold' }),
  font_size = 11
}
config.native_macos_fullscreen_mode = true

return config
