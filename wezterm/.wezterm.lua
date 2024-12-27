-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.font_size = 16.0
-- config.color_scheme = "Catppuccin Macchiato"
config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
}

config.max_fps = 120

-- and finally, return the configuration to wezterm
return config
