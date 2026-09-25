-- Configure Hyprland options
-- See https://wiki.hypr.land/configuring/core/config-options

local active_color = 0xaa919191
local inactive_color = 0xaa474747

hl.config({
	general = {
		-- Configure gaps between windows
		gaps_out = 5,
		gaps_workspaces = 30,

		col = {
			-- Configure window border color
			active_border = active_color,
			inactive_border = inactive_color,
		},

		-- Allow resizing windows by dragging on borders
		resize_on_border = true,

		-- Do not fall back to the next available window when moving focus in a direction where no window was found
		no_focus_fallback = true,
	},

	decoration = {
		-- Declare the radius of window corner
		rounding = 12,

		-- Configure window opacity
		active_opacity = 0.9,
		inactive_opacity = 0.8,

		-- Enables dimming of inactive windows
		dim_inactive = true,
		dim_strength = 0.1,

		blur = {
			-- Specify blur variant
			--variant = "fluid_jar",
		},
	},

	input = {
		-- Enable numlock by default
		numlock_by_default = true,

		-- Configure held-down keys
		repeat_delay = 250,
		repeat_rate = 35,

		touchpad = {
			-- Enable natural scroll
			natural_scroll = true,

			-- Button presses with 1, 2, or 3 fingers will be mapped to LMB, RMB, and MMB respectively
			clickfinger_behavior = true,
		},
	},

	group = {
		col = {
			-- Configure group border color
			border_active = active_color,
			border_inactive = inactive_color,
		},

		groupbar = {
			-- Configure font size & height
			font_size = 14,
			height = 18,

			-- Configure gaps between bars
			gaps_in = 10,
			gaps_out = 5,

			col = {
				-- Configure groupbar color
				active = active_color,
				inactive = inactive_color,
			},
		},
	},

	misc = {
		-- Configure global font
		font_family = "JetBrainsMonoNL Nerd Font",

		-- Wake up the monitors on mouse move or key press
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,

		-- Enable VRR
		vrr = 1,

		-- Allow restarting a lock screen app in case it crashes
		allow_session_lock_restore = true,

		-- Disable Hyprland's default background
		disable_hyprland_logo = true,
	},

	ecosystem = {
		-- Disable popups on launch
		no_donation_nag = true,
		no_update_news = true,
	},
})
