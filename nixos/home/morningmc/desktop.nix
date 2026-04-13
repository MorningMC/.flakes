{ config, pkgs, system, quickshell, ... }:

{
	users.users.morningmc.packages = with pkgs; [
		# Hypr ecosystem
		hyprlock
		hypridle
		hyprpicker # Color picker
		hyprshutdown # Graceful shutdown

		# Hyprland plugins
		hyprlandPlugins.hyprsplit

		dbus # Event bus
		quickshell.packages.${system}.default # Quickshell from flake
		
		# KDE theme
		kdePackages.breeze
		kdePackages.breeze-icons

		# Other utilities (used by Illogical Impulse)
		inetutils # Provides hostname, ifconfig, ping, etc.
		libnotify # Provides notify-send
		libqalculate # Provides calculator widget
		wl-clipboard # Wayland clipboard service
		fuzzel # Application launcher
		cliphist # Clipboard manager
		playerctl # MPRIS controller
		imagemagick # Used when screenshotting
		matugen
		curl
		
		material-symbols # Contains icons
		bibata-cursors
	];
	
	# Enable Plasma 6 desktop environment
	services.desktopManager.plasma6.enable = true;

	programs = {
		# Enable Hyprland & XWayland
		hyprland = {
			enable = true;
			xwayland.enable = true;
		};

		# Enable ydotool
		ydotool.enable = true;
	};

	# Enable XDG desktop portals
	xdg.portal = {
		enable = true;

		# Enable platform-specific portals.
		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
		];

		# Use configurations provided by portals.
		configPackages = config.xdg.portal.extraPortals;
	};

	# Setup environment variables
	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
		MOZ_ENABLE_WAYLAND = "1";
		QT_QPA_PLATFORM = "wayland;xcb";
		QT_QPA_PLATFORMTHEME = "kde";
		XDG_MENU_PREFIX = "plasma-";
		XDG_SESSION_TYPE = "wayland";
		GDK_BACKEND = "wayland";
	};
	
	# Secret agents
	security.polkit.enable = true;
	services.gnome.gnome-keyring.enable = true;
}
