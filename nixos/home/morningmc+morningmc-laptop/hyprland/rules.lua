-- Define rules
-- See https://wiki.hypr.land/configuring/core/rules

-- Disable blur and borders for XWayland context menus
hl.window_rule({
	match = { class = "^$", title = "^$" },
	float = true,
	no_initial_focus = true,
	no_shadow = true,
	border_size = 0,
})

hl.window_rule({ match = { xwayland = true }, no_shadow = true })

-- Make file selection windows floating
local file_picker_titles = {
	"Open File.*",
	"Select a File.*",
	"Open Folder.*",
	"Save As.*",
	"Library.*",
	"File Upload.*",
	".*wants to save",
	".*wants to open",
}

for _, title_pattern in ipairs(file_picker_titles) do
	hl.window_rule({ match = { title = title_pattern }, float = true, center = true })
end

hl.window_rule({
	match = { title = "Choose wallpaper.*" },
	float = true,
	center = true,
	size = { "(monitor_w*.60)", "(monitor_h*.60)" },
})
hl.window_rule({
	match = { class = "org.freedesktop.impl.portal.desktop.kde" },
	float = true,
	size = { "(monitor_w*.60)", "(monitor_h*.60)" },
})

-- Picture-in-Picture (opaque by default)
hl.window_rule({
	match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
	float = true,
	keep_aspect_ratio = true,
	move = { "(monitor_w*.70)", "(monitor_h*.70)" },
	size = { "(monitor_w*.25)", "(monitor_h*.25)" },
	opaque = true,
	pin = true,
})

-- Use float window for Polkit and stay focused
hl.window_rule({ match = { class = ".*polkit-kde.*" }, float = true, stay_focused = true })

-- Use float window for PipeWire volume control
hl.window_rule({
	match = { class = "com.saivert.pwvucontrol" },
	float = true,
	center = true,
	size = { "(monitor_w*.60)", "(monitor_h*.60)" },
})

-- Make GIMP window opaque by default
hl.window_rule({ match = { class = "\\.?gimp.*" }, opaque = true })

-- Use float window for GIMP Load SVG dialog
hl.window_rule({ match = { class = "file-svg" }, float = true })

-- Make all Kdenlive windows opaque by default
hl.window_rule({ match = { class = "org.kde.kdenlive" }, opaque = true })

-- Adjust size for Kdenlive Import dialog, Title clip editor & Render dialog
hl.window_rule({
	match = { class = "org.kde.kdenlive", title = "Kdenlive" },
	center = true,
	size = { "(monitor_w*.70)", "(monitor_h*.70)" },
})
hl.window_rule({
	match = { class = "org.kde.kdenlive", title = "^(Title Clip — Kdenlive)$" },
	center = true,
	size = { "(monitor_w*.80)", "(monitor_h*.80)" },
})
hl.window_rule({
	match = { class = "org.kde.kdenlive", title = "^(Rendering — Kdenlive)$" },
	center = true,
	size = { "(monitor_w*.70)", "(monitor_h*.70)" },
})

-- Make Blockbench main window opaque by default
hl.window_rule({ match = { class = "blockbench" }, opaque = true })

-- Make Blender main window opaque by default
hl.window_rule({ match = { class = "blender", title = ".*( - Blender ).*" }, opaque = true })

-- Make Blender subwindows floating & in comfortable size
hl.window_rule({
	match = { class = "blender", title = "negative:.*( - Blender ).*" },
	float = true,
	center = true,
	size = { "(monitor_w*.70)", "(monitor_h*.70)" },
})

-- Make HMCL subwindows floating & adjust size for log window
hl.window_rule({
	match = {
		class = "org.jackhuang.hmcl.Launcher",
		title = "negative:.*(Hello Minecraft! Launcher).*",
	},
	float = true,
})
hl.window_rule({
	match = { class = "org.jackhuang.hmcl.Launcher", title = "Log" },
	center = true,
	size = { "(monitor_w*.60)", "(monitor_h*.60)" },
})

-- Make Minecraft window opaque by default
hl.window_rule({ match = { class = ".*[Mm]inecraft.*" }, opaque = true })
hl.window_rule({ match = { title = ".*[Mm]inecraft.*" }, opaque = true })

-- Fix JetBrains IDEs focus/rerendering problem
hl.window_rule({
	match = {
		class = "^jetbrains-.*$",
		float = true,
		title = "^$|^\\s$|^win\\d+$",
	},
	no_initial_focus = true,
})

-- Make Webcamoid window opaque by default
hl.window_rule({ match = { class = "io.github.webcamoid." }, opaque = true })

-- Make Haruna window opaque by default
hl.window_rule({ match = { class = "org.kde.haruna" }, opaque = true })

-- Use float window for QQ subwindows
hl.window_rule({ match = { class = "QQ", title = "negative:QQ" }, float = true })
