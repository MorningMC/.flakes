-- Specify touchpad gestures
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" }) -- Switch workspaces
hl.gesture({ fingers = 4, direction = "swipe", action = "move" }) -- Move windows

-- Configure general options
hl.config({
	gestures = {
		-- Configure how much the swipe has to proceed in order to commence it
		workspace_swipe_cancel_ratio = 0.2,

		-- Configure minimum speed to force the change ignoring cancel_ratio
		workspace_swipe_min_speed_to_force = 5,
	},
})
