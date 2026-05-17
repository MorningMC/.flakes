{ config, lib, pkgs, ... }: {
	home-manager.users.morningmc = {
		# Enable Hyprlock
		programs.hyprlock = {
			enable = true;

			settings = {
				"$font" = "JetbrainsMonoNL Nerd Font"; # Declare font family used to render text
				"$text_color" = "rgb(DAE2FF)"; # Declare accent color used to render text

				# Declare background style
				background = {
					# Use a screenshot of current desktop as background
					path = "screenshot";

					# Blur background
					blur_passes = 3;
					blur_size = 8;
				};

				# Declare input field style
				input-field = {
					# Specify position and size
					position = "0, 15";
					size = "15%, 40";
					halign = "center";
					valign = "bottom";

					# Declare text style
					font_family = "$font";
					font_color = "$text_color";

					# Declare color
					inner_color = "rgb(14181D)";
					outer_color = "rgb(282A2E)";
					outline_thickness = 1;

					# Do not hide input field when no input
					fade_on_empty = false;
				};

				# Declare labels
				label = [
					# Display time
					{
						# Specify position and size
						position = "0, 300";
						halign = "center";
						valign = "center";

						# Declare text style
						text = "$TIME";
						color = "$text_color";
						font_family = "$font";
						font_size = 72;
					}

					# Display date
					{
						# Specify position and size
						position = "0, 240";
						halign = "center";
						valign = "center";

						# Declare text style
						text = "cmd[update:5000] date \"+%m-%d %a\""; # Get date every 5 seconds
						color = "$text_color";
						font_family = "$font";
						font_size = 16;
					}

					# Display user
					{
						# Specify position and size
						position = "0, 70";
						halign = "center";
						valign = "bottom";

						# Declare text style
						text = "  $USER";
						color = "$text_color";
						font_family = "$font";
						font_size = 16;
					}

					# Display battery status
					(let
						# Declare shell script to fetch battery status
						batteryStatus = pkgs.writeShellScriptBin "battery-status" ''
							for battery in /sys/class/power_supply/*BAT*; do
								# Continue the for-loop if $battery/uevent does not exists
								[[ -f "$battery/uevent" ]] || continue

								echo "$(cat "$battery/capacity")% $(cat "$battery/status")"
								break
							done
						'';
					in
					{
						# Specify position and size
						position = "30, 30";
						halign = "left";
						valign = "bottom";

						# Declare text style
						text = "cmd[update:5000] ${lib.getExe batteryStatus}";
						color = "$text_color";
						font_family = "$font";
						font_size = 14;
					})

					# Display keyboard layout
					{
						# Specify position and size
						position = "-30, 30";
						halign = "right";
						valign = "bottom";

						# Declare text style
						text = "$LAYOUT";
						color = "$text_color";
						font_family = "$font";
						font_size = 14;
					}
				];
			};
		};

		# Register Hyprlock as a Systemd service
		systemd.user.services.hyprlock = let
			# Specify required graphical session target
			sessionTarget = [ config.home-manager.users.morningmc.wayland.systemd.target ];
		in
		{
			Unit = {
				Description = "hyprlock";

				# Run only when specified target is active
				BindsTo = sessionTarget;
				After = sessionTarget;
			};

			Service = {
				# Command executed on service start
				ExecStart = lib.getExe pkgs.hyprlock;

				# Restart Hyprlock on failure
				Restart = "on-failure";
			};
		};
	};

	# Enable PAM module to perform authentication
	security.pam.services.hyprlock = { };
}
