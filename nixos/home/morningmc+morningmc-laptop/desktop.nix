{ config, lib, pkgs, inputs, ... }: {
	users.users.morningmc.packages = with pkgs; [
		wl-clipboard # Wayland clipboard service
		bibata-cursors # Cursor theme
	];

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
		# Enable XDG desktop portals
		xdg.portal = {
			enable = true;

			# Enable platform-specific portals
			extraPortals = config.xdg.portal.extraPortals;

			# Use configurations provided by portals
			configPackages = config.xdg.portal.extraPortals;

			# Make xdg-open use the portal to open programs
			xdgOpenUsePortal = true;
		};

		# Setup environment variables
		home.sessionVariables = {
			NIXOS_OZONE_WL = 1;
			QT_QPA_PLATFORM = "wayland;xcb";
			QT_QPA_PLATFORMTHEME = "kde";
			XDG_MENU_PREFIX = "plasma-";
			GDK_BACKEND = "wayland";
		};
	};

	# Required by user-scope XDG desktop portals to work
	environment.pathsToLink = lib.mkIf config.home-manager.useUserPackages [ "/share/xdg-desktop-portal" "/share/applications" ];
}
