-- Specify monitors
-- See https://wiki.hypr.land/Configuring/Basics/Monitors

-- General monitor setup
hl.monitor({ output = "", scale = 1, cm = "auto" })

-- Recommended rule for quickly plugging in random monitors
--hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Monitor-specific setup
hl.monitor({ output = "desc:EDH MD140QH 0x20260428", mode = "2880x1800@60.00Hz", scale = 1.5 })

-- Bind tablet inputs to its monitor
hl.device({
	name = "hanvon-ugee-artist-ultra-14",
	output = "desc:EDH MD140QH 0x20260428",
})
