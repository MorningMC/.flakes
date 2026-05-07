{ config, pkgs, ... }: {
	users.users.morningmc.packages = with pkgs; [
		# Hypr ecosystem
		hyprlock # Lock login session
		hypridle # Idle management daemon
		hyprpicker # Color picker
		hyprshutdown # Graceful shutdown

		# Hyprland plugins
		hyprlandPlugins.hyprsplit
	];

	# Enable Hyprland & XWayland
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};
}
