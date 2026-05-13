{ config, pkgs, ... }: {
	users.users.morningmc.packages = with pkgs; [
		# Hypr ecosystem
		hyprlock # Lock login session
		hyprpicker # Color picker
		hyprshutdown # Graceful shutdown
	];

	# Enable Hyprland
	programs.hyprland.enable = true;

	home-manager.users.morningmc = {
		# Manage Hyprland by Home Manager
		wayland.windowManager.hyprland = {
			enable = true;
			package = null; # Using system Hyprland package

			# Source configurations
			settings.source = "${config.users.users.morningmc.home}/.config/hypr/hyprland/*";

			# Declare enabled plugins
			plugins = with pkgs.hyprlandPlugins; [
				hyprsplit
			];
		};

		# Enable Hypridle
		services.hypridle = {
			enable = true;

			settings = {
				# Declare general settings
				general = {
					# Specify command executed when locking user session
					lock_cmd = "hyprctl dispatch global quickshell:lock & pidof qs quickshell hyprlock || hyprlock";

					# Specify command executed before sleep
					before_sleep_cmd = "loginctl lock-session";

					# Specify command executed after resuming from sleep
					after_sleep_cmd = "hyprctl dispatch global quickshell:lockFocus";
				};

				# Declare idle timers
				listener = [
					# Lock screen timer
					{
						timeout = 300; # 5 mins
						on-timeout = "loginctl lock-session";
					}

					# Close screen timer
					{
						timeout = 600; # 10 mins
						on-timeout = "hyprctl dispatch dpms off";
						on-resume = "hyprctl dispatch dpms on";
					}

					# Suspend timer
					{
						timeout = 1200; # 20 mins
						on-timeout = "systemctl suspend";
					}
				];
			};
		};
	};
}
