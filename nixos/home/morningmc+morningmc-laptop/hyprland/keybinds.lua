-- Specify keybinds
-- See https://wiki.hypr.land/Configuring/Basics/Binds

local main_mod = "SUPER"

-- Applications
local terminal = "kitty"
local browser = "brave"
local file_manager = "dolphin"

------------ Helper functions ------------
-- Construct Noctalia IPC dispatcher
local noctalia_msg = function(command)
	return hl.dsp.exec_cmd("noctalia msg " .. command)
end

-- Construct dispatcher that configures the active workspace's layout
local config_layout = function(layout)
	return function()
		hl.workspace_rule({ workspace = hl.get_active_workspace().id, layout = layout })
	end
end

-- Construct dispatcher that triggers a dispatcher on a certain workspace within a group
local dispatch_workspace = function(workspace, action, group_size)
	return function()
		local target_workspace = math.floor((hl.get_active_workspace().id - 1) / group_size) * group_size + workspace
		hl.dispatch(action({ workspace = target_workspace }))
	end
end

------------ Action keybinds ------------
-- General actions
hl.bind(main_mod .. " + escape", hl.dsp.window.close()) -- Close current window
hl.bind(main_mod .. " + SHIFT + escape", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true }) -- Lock screen (global keybind)
hl.bind(main_mod .. " + CTRL + escape", hl.dsp.exec_cmd("hyprshutdown"), { long_press = true }) -- Exit Hyprland with hyprshutdown (require long press)
hl.bind(main_mod .. " + F11", hl.dsp.window.fullscreen({ mode = "maximized" })) -- Maximize the window
hl.bind(main_mod .. " + SHIFT + F11", hl.dsp.window.fullscreen({ mode = "fullscreen" })) -- Open the window in fullscreen
hl.bind(main_mod .. " + F3", function() -- Toggle debug overlay
	hl.config({ ["debug.overlay"] = not hl.get_config("debug.overlay") })
end)
--hl.bind(main_mod .. " + SHIFT + R", hl.dsp.reload_config()) -- Reload Hyprland config

-- Application shortcuts
hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(terminal)) -- Open terminal
hl.bind(main_mod .. " + SHIFT + RETURN", noctalia_msg("panel-toggle launcher")) -- Open overview
hl.bind(main_mod .. " + V", noctalia_msg("panel-toggle clipboard")) -- Open clipboard history
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd(browser)) -- Open the browser
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager)) -- Open the file manager
hl.bind(main_mod .. " + I", hl.dsp.exec_cmd("systemsettings")) -- Open KDE System Settings
hl.bind(main_mod .. " + P", hl.dsp.exec_cmd("pwvucontrol")) -- Open Volume Control
hl.bind(main_mod .. " + SHIFT + P", hl.dsp.exec_cmd("crosspipe")) -- Open PipeWire device control
hl.bind(main_mod .. " + O", hl.dsp.exec_cmd("hyprpicker -a")) -- Pick color

-- Media (Fn) keys (global keybinds)
hl.bind("XF86AudioRaiseVolume", noctalia_msg("volume-up"), { locked = true, repeat_press = true }) -- Increase volume (repeat when held)
hl.bind("XF86AudioLowerVolume", noctalia_msg("volume-down"), { locked = true, repeat_press = true }) -- Decrease volume (repeat when held)
hl.bind("XF86MonBrightnessUp", noctalia_msg("brightness-up"), { locked = true, repeat_press = true }) -- Increase brightness (repeat when held)
hl.bind("XF86MonBrightnessDown", noctalia_msg("brightness-down"), { locked = true, repeat_press = true }) -- Decrease brightness (repeat when held)
hl.bind("XF86AudioMute", noctalia_msg("volume-mute"), { locked = true }) -- Toggle speaker mute
hl.bind("XF86AudioMicMute", noctalia_msg("mic-mute"), { locked = true }) -- Toggle microphone mute
hl.bind("XF86WLAN", noctalia_msg("wifi-toggle"), { locked = true }) -- Toggle wifi

-- Screenshot actions
hl.bind(main_mod .. " + F2", hl.dsp.submap("screenshot")) -- Enter screenshot submap
hl.define_submap("screenshot", "reset", function()
	hl.bind("E", noctalia_msg("screenshot-region"), { ignore_mods = true }) -- Take regional screenshot (ignore modifiers)
	hl.bind("F", noctalia_msg("screenshot-fullscreen"), { ignore_mods = true }) -- Take full-screen screenshot (ignore modifiers)
	hl.bind("catchall", hl.dsp.submap("reset"), { release = true }) -- Escape from screenshot submap (trigger when key release)
end)

-- Layout selection
hl.bind(main_mod .. " + SHIFT + C", function() -- Enter layout submap
	hl.notification.create({ text = "Entered layout submap", timeout = 3000 })
	hl.dispatch(hl.dsp.submap("layout"))
end)
hl.define_submap("layout", "reset", function()
	hl.bind("D", config_layout("dwindle"), { ignore_mods = true }) -- Switch to dwindle layout (ignore modifiers)
	hl.bind("M", config_layout("master"), { ignore_mods = true }) -- Switch to master layout (ignore modifiers)
	hl.bind("S", config_layout("scrolling"), { ignore_mods = true }) -- Switch to scrolling layout (ignore modifiers)
	hl.bind("catchall", hl.dsp.submap("reset"), { release = true }) -- Escape from layout submap (trigger when key release)
end)

-- Power options (global keybinds, require long press)
hl.bind(main_mod .. " + ALT + escape", function() -- Enter power submap
	hl.notification.create({ text = "Entered power submap", timeout = 3000 })
	hl.dispatch(hl.dsp.submap("power"))
end, { locked = true })
hl.define_submap("power", "reset", function()
	hl.bind("P", hl.dsp.exec_cmd("hyprshutdown -t 'Shutting down...' --post-cmd \"systemctl poweroff\""), { locked = true, long_press = true }) -- Power-off the system
	hl.bind("SHIFT + P", hl.dsp.exec_cmd("hyprshutdown -t 'Shutting down...' --post-cmd \"systemctl poweroff --firmware-setup\""), { locked = true, long_press = true }) -- Power-off the system and enter firmware setup on next boot
	hl.bind("R", hl.dsp.exec_cmd("hyprshutdown -t 'Rebooting...' --post-cmd \"systemctl reboot\""), { locked = true, long_press = true }) -- Reboot the system
	hl.bind("SHIFT + R", hl.dsp.exec_cmd("hyprshutdown -t 'Rebooting...' --post-cmd \"systemctl reboot --firmware-setup\""), { locked = true, long_press = true }) -- Reboot the system and enter firmware setup on boot
	hl.bind("S", hl.dsp.exec_cmd("systemctl suspend"), { locked = true, long_press = true }) -- Suspend the system
	hl.bind("H", hl.dsp.exec_cmd("systemctl hibernate"), { locked = true, long_press = true }) -- Hibernate the system
	hl.bind("catchall", hl.dsp.submap("reset"), { locked = true, release = true }) -- Escape from power submap (trigger when key release)
end)

-- Toggle all Hyprland keybinds
hl.bind(main_mod .. " + CTRL + F3", function() -- Clear keybinds
	hl.notification.create({ text = "Cleared all keybinds", timeout = 3000 })
	hl.dispatch(hl.dsp.submap("clear"))
end)
hl.define_submap("clear", function()
	hl.bind(main_mod .. " + CTRL + F3", function() -- Re-enable keybinds
		hl.notification.create({ text = "Returned to normal keymap", timeout = 3000 })
		hl.dispatch(hl.dsp.submap("reset"))
	end)
end)

------------ Window keybinds ------------
-- Toggles the current window’s floating state
hl.bind(main_mod .. " + T", hl.dsp.window.float())

-- Toggles the current window's opaque state
hl.bind(main_mod .. " + CTRL + T", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }))

-- Move focus
hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "l" })) -- Move focus left
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "r" })) -- Move focus right
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "u" })) -- Move focus up
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "d" })) -- Move focus down

-- Move window or move into / out of groups
hl.bind(main_mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l", group_aware = true })) -- Move window left
hl.bind(main_mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r", group_aware = true })) -- Move window right
hl.bind(main_mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u", group_aware = true })) -- Move window up
hl.bind(main_mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d", group_aware = true })) -- Move window down

-- Cycle through windows
hl.bind(main_mod .. " + semicolon", hl.dsp.window.cycle_next({ next = false })) -- Cycle to previous window
hl.bind(main_mod .. " + apostrophe", hl.dsp.window.cycle_next()) -- Cycle to next window

-- Grouped windows
hl.bind(main_mod .. " + SHIFT + T", hl.dsp.group.toggle()) -- Toggles the current active window into a group
hl.bind(main_mod .. " + SHIFT + semicolon", hl.dsp.group.prev()) -- Switches to the previous window in a group
hl.bind(main_mod .. " + SHIFT + apostrophe", hl.dsp.group.next()) -- Switches to the next window in a group

-- Adjust split ratio (repeat when held)
hl.bind(main_mod .. " + CTRL + semicolon", hl.dsp.layout("splitratio -0.01"), { repeat_press = true }) -- Decrease split ratio
hl.bind(main_mod .. " + CTRL + apostrophe", hl.dsp.layout("splitratio +0.01"), { repeat_press = true }) -- Increase split ratio

-- Move/resize windows
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- Move window with LMB
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Resize window with RMB

------------ Workspace keybinds ------------
-- Switch workspaces in current workspace group
local group_size = 10
local keypad_keys = { "87", "88", "89", "83", "84", "85", "79", "80", "81", "90" }

for workspace = 1, group_size do
	-- Number keys
	hl.bind(main_mod .. " + " .. workspace % group_size, dispatch_workspace(workspace, hl.dsp.focus, group_size))
	hl.bind(main_mod .. " + SHIFT + " .. workspace % group_size, dispatch_workspace(workspace, hl.dsp.window.move, group_size))

	-- Keypad numbers
	hl.bind(main_mod .. " + code:" .. keypad_keys[workspace], dispatch_workspace(workspace, hl.dsp.focus, group_size))
	hl.bind(main_mod .. " + SHIFT + code:" .. keypad_keys[workspace], dispatch_workspace(workspace, hl.dsp.window.move, group_size))
end

-- Scroll through workspaces
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "-1" })) -- Scroll to previous workspace
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "+1" })) -- Scroll to next workspace
hl.bind(main_mod .. " + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "-1" })) -- Move window to previous workspace
hl.bind(main_mod .. " + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "+1" })) -- Move window to next workspace

-- Switch between workspace groups
hl.bind(main_mod .. " + minus", hl.dsp.focus({ workspace = "-10" })) -- Switch to previous workspace group
hl.bind(main_mod .. " + equal", hl.dsp.focus({ workspace = "+10" })) -- Switch to next workspace group
hl.bind(main_mod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "-10" })) -- Move window to previous workspace group
hl.bind(main_mod .. " + SHIFT + equal", hl.dsp.window.move({ workspace = "+10" })) -- Move window to next workspace group

-- Special Workspace
local special_name = "scratch"

hl.bind(main_mod .. " + grave", hl.dsp.workspace.toggle_special(special_name)) -- Toggle special workspace
hl.bind(main_mod .. " + SHIFT + grave", function() -- Toggle window into/out of special workspace
	if hl.get_active_special_workspace() and hl.get_active_special_workspace().name == "special:" .. special_name then
		hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
	else
		hl.dispatch(hl.dsp.window.move({ workspace = "special:" .. special_name, follow = false }))
	end
end)
