-- Specify apps launch on Hyprland start
-- See https://wiki.hypr.land/Configuring/Basics/Autostart

hl.on("hyprland.start", function ()
	-- Launch Noctalia shell
	hl.exec_cmd("noctalia")

	-- Launch Fcitx5 input method
	hl.exec_cmd("fcitx5")
end)
