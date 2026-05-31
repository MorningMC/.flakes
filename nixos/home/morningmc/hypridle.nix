{
	# Enable Hypridle
	home-manager.users.morningmc.services.hypridle = {
		enable = true;

		settings = {
			# Declare general settings
			general = {
				# Specify command executed when locking user session
				lock_cmd = "systemctl --user start hyprlock.service"; # Hyprlock is registered as Systemd service in ./hyprlock.nix

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
}
