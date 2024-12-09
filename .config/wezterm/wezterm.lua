local wt = require("wezterm")
local act = wt.action
local config = wt.config_builder()

-- colorscheme overrides
local custom_cat = wt.color.get_builtin_schemes()["Catppuccin Mocha"]
custom_cat.background = "#08080d"
custom_cat.tab_bar.background = "#040404"
custom_cat.tab_bar.inactive_tab.bg_color = "#0f0f0f"
custom_cat.tab_bar.new_tab.bg_color = "#080808"
config.color_schemes = {
	["CustomCatppuccin"] = custom_cat,
}
config.color_scheme = "CustomCatppuccin"

wt.on("toggle-opacity", function(win)
	local overrides = win:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1.0
	else
		overrides.window_background_opacity = nil
	end
	win:set_config_overrides(overrides)
end)

config.default_prog = { "pwsh", "-NoLogo" }
config.window_close_confirmation = "NeverPrompt"

local opacity = 0.75
config.window_background_opacity = opacity

config.enable_scroll_bar = true
config.initial_cols = 140
config.initial_rows = 30
config.max_fps = 240
config.animation_fps = 24
config.front_end = "OpenGL"
config.term = "xterm-256color"
config.cell_width = 0.9
config.line_height = 1
config.allow_square_glyphs_to_overflow_width = "Never"

-- Theme and Font
config.font = wt.font_with_fallback({
	-- Personal Iosevka Config
	{
		family = "Iosevka Rvn",
		weight = 500,
		italic = false,
		harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	},
	-- { family = "Iosevka Custom", weight = 500, italic = false, harfbuzz_features = { "calt=0", "clig=0", "liga=0" } },
	{ family = "Sarasa Mono J", weight = 500, italic = false },
})

config.font_size = 17

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.audible_bell = "Disabled"

-- Keybinds
config.leader = { key = "a", mods = "CTRL" }
config.keys = {
	{ key = "a", mods = "LEADER|CTRL", action = act({ SendString = "\x01" }) },
	{ key = "-", mods = "LEADER", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "\\", mods = "LEADER", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "s", mods = "LEADER", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "v", mods = "LEADER", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "o", mods = "LEADER", action = act.EmitEvent("toggle-opacity") },
	{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = act({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = act({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = act({ ActivatePaneDirection = "Right" }) },
	{ key = "H", mods = "LEADER", action = act({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER", action = act({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER", action = act({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER", action = act({ AdjustPaneSize = { "Right", 5 } }) },
	{ key = "p", mods = "LEADER", action = act({ ActivateTabRelative = -1 }) },
	{ key = "n", mods = "LEADER", action = act({ ActivateTabRelative = 1 }) },
	{ key = "1", mods = "LEADER", action = act({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = act({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = act({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = act({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = act({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = act({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = act({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = act({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = act({ ActivateTab = 8 }) },
	{ key = "&", mods = "LEADER", action = act({ CloseCurrentTab = { confirm = true } }) },
	{ key = "d", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
	{ key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },
	-- manual scrolling
	-- { key = "UpArrow", mods = "LEADER", action = act({ ScrollByPage = -0.5 }) },
	-- { key = "DownArrow", mods = "LEADER", action = act({ ScrollByPage = 0.5 }) },
}

function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wt.on("format-tab-title", function(tab, _, _, _, hover)
	local edge_background = "#0b0022"
	local background = "#1b1032"
	local foreground = "#808080"

	if tab.is_active then
		background = "#2b2042"
		foreground = "#c0c0c0"
	elseif hover then
		background = "#3b3052"
		foreground = "#909090"
	end

	local edge_foreground = background

	local title = tab_title(tab)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
	}
end)

return config
