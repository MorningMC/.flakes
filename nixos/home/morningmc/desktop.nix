{ config, pkgs, system, quickshell, ... }: {
	users.users.morningmc.packages = with pkgs; [
		# Hypr ecosystem
		hyprlock # Lock login session
		hypridle # Idle management daemon
		hyprpicker # Color picker
		hyprshutdown # Graceful shutdown

		# Hyprland plugins
		hyprlandPlugins.hyprsplit

		# Quickshell from flake
		quickshell.packages.${system}.default

		# Other utilities (used by Illogical Impulse)
		inetutils # Provides hostname, ifconfig, ping, etc.
		libnotify # Provides notify-send
		libqalculate # Provides calculator widget
		wl-clipboard # Wayland clipboard service
		fuzzel # Application launcher
		cliphist # Clipboard manager
		playerctl # MPRIS controller
		imagemagick # Used when screenshotting
		ddcutil
		matugen
		
		# Cursor theme
		bibata-cursors
	];

	# Enable material symbols icon for Illogical Impulse
	fonts.packages = with pkgs; [ material-symbols ];

	# Use modern broker D-Bus implementation
	services.dbus.implementation = "broker";

	programs = {
		# Enable Hyprland & XWayland
		hyprland = {
			enable = true;
			xwayland.enable = true;
		};

		# Enable ydotool
		ydotool.enable = true;
	};
	
	# Enable Plasma 6 desktop environment
	services.desktopManager.plasma6.enable = true;
	environment.plasma6.excludePackages = with pkgs.kdePackages; [
		kate
		gwenview
		okular
		elisa
		qrca
		discover
		konsole
		spectacle
		plasma-systemmonitor
		kwallet
		kwalletmanager
	];

	home-manager.users.morningmc = {
		services = {
			# Automatically start GNOME Keyring
			gnome-keyring.enable = true;

			# Enable Policykit agent
			polkit-gnome.enable = true;
		};

		# Enable XDG desktop portals
		xdg.portal = {
			enable = true;

			# Enable platform-specific portals.
			extraPortals = config.xdg.portal.extraPortals;

			# Use configurations provided by portals.
			configPackages = config.xdg.portal.extraPortals;
		};

		# Setup environment variables
		home.sessionVariables = {
			NIXOS_OZONE_WL = 1;
			QT_QPA_PLATFORM = "wayland;xcb";
			QT_QPA_PLATFORMTHEME = "kde";
			XDG_MENU_PREFIX = "plasma-";
			XDG_SESSION_TYPE = "wayland";
			GDK_BACKEND = "wayland";
		};
	};

	# Enable Policykit daemon
	security.polkit.enable = true;

	# Enable GNOME Keyring
	services.gnome.gnome-keyring.enable = true;
}
