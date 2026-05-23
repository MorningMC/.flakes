{ config, lib, pkgs, ... }: {
	# Declare Hyprlock configurations
	home-manager.users.morningmc.programs.hyprlock.settings = {
		"$font" = "JetbrainsMonoNL Nerd Font"; # Declare font family used to render text
		"$text_color" = "rgb(DAE2FF)"; # Declare accent color used to render text
		"$secondary_text_color" = "rgb(A3ABC6)"; # Declare secondary color used to render text

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
				# Specify position
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
				# Specify position
				position = "0, 240";
				halign = "center";
				valign = "center";

				# Declare text style
				text = "cmd[update:5000] date \"+%Y-%m-%d %A\""; # Get date every 5 seconds
				color = "$secondary_text_color";
				font_family = "$font";
				font_size = 18;
			}

			# Display user
			{
				# Specify position
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
				batteryStatus = pkgs.writeShellApplication {
					name = "battery-status";
					text = lib.fileContents ./battery-status.sh;
				};
			in
			{
				# Specify position
				position = "30, 30";
				halign = "left";
				valign = "bottom";

				# Declare text style
				text = "cmd[update:5000] ${lib.getExe batteryStatus}"; # Get battery status every 5 seconds
				color = "$secondary_text_color";
				font_family = "$font";
				font_size = 14;
			})

			# Display keyboard layout
			{
				# Specify position
				position = "-30, 30";
				halign = "right";
				valign = "bottom";

				# Declare text style
				text = "$LAYOUT";
				color = "$secondary_text_color";
				font_family = "$font";
				font_size = 14;
			}
		];
	};
}
