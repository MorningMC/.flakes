{ config, pkgs, ... }: {
	users.users.morningmc.packages = with pkgs; [
		# Hypr ecosystem
		hyprpicker # Color picker
		hyprshutdown # Graceful shutdown
	];

	# Enable Hyprland
	programs.hyprland.enable = true;

	# Manage Hyprland by Home Manager
	home-manager.users.morningmc.wayland.windowManager.hyprland = {
		enable = true;
		package = null; # Using system Hyprland package

		# Source configurations
		settings.source = "${config.users.users.morningmc.home}/.config/hypr/hyprland/*";

		# Declare enabled plugins
		plugins = with pkgs.hyprlandPlugins; [
			hyprsplit
		];
	};
}
