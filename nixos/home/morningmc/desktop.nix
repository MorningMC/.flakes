{ config, pkgs, system, quickshell, ... }:

{
	users.users.morningmc.packages = with pkgs; [
		# Hypr ecosystem
		hyprlock
		hypridle
		hyprpicker # Color picker

		dbus # Event bus
		quickshell.packages.${system}.default # Quickshell from flake
		
		# KDE theme
		kdePackages.breeze
		kdePackages.breeze-icons

		# Other utilities (used by Illogical Impulse)
		inetutils # Provides hostname, ifconfig, ping, etc.
		libnotify # Provides notify-send
		wl-clipboard # Wayland clipboard service
		cliphist # Clipboard manager
		playerctl # MPRIS controller
		imagemagick # Used when screenshotting
		matugen
		curl
		ydotool
		
		material-symbols # Contains icons
		bibata-cursors
	];
	
	# Enable Plasma 6 desktop environment
	services.desktopManager.plasma6.enable = true;

	# Enable Hyprland & XWayland
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

	# Enable XDG desktop portals
	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
			kdePackages.xdg-desktop-portal-kde
		];
		configPackages = with pkgs; [
			xdg-desktop-portal-gtk
			kdePackages.xdg-desktop-portal-kde
		];
	};
	
	# Secret agents
	security.polkit.enable = true;
	services.gnome.gnome-keyring.enable = true;
}
