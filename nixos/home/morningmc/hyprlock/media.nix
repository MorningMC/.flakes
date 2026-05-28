{ config, lib, pkgs, ... }: {
	# Declare media widgets in Hyprlock configurations
	home-manager.users.morningmc.programs.hyprlock.settings = {
		# Declare images
		image = [
			# Display media album art
			(let
				# Declare shell script to fetch media album art image
				fetchAlbumArt = pkgs.writeShellApplication {
					name = "fetch-album-art";
					runtimeInputs = with pkgs; [ curl playerctl imagemagick ];
					text = lib.fileContents ./fetch-album-art.sh;
				};
			in
			{
				# Specify position and size
				position = "-200, -200";
				size = 150;
				halign = "center";
				valign = "center";

				# Specify image loading script
				reload_cmd = lib.getExe fetchAlbumArt;
				reload_time = 0; # Reload when Hyprlock recieved SIGUSR2 update

				# Declare image style
				rounding = 10;
				border_size = 0;
				zindex = 1; # Render above the placeholder shape
			})
		];

		# Declare shapes
		shape = [
			# Display a placeholder of the media album art if the image is empty
			{
				# Specify position and size
				position = "-200, -200";
				size = "150, 150";
				halign = "center";
				valign = "center";

				# Declare shape attributes
				color = "rgba(808080B0)";
				rounding = 10;
			}
		];

		# Declare labels
		label = let
			# Utility function to construct the command that fetches specific media metadata. Note that double curly braces in key parameter
			# needs to have backslash prepended to them to prevent Hyprlang parsing them incorrectly.
			getMediaMetadata = key: "cmd[update:0:true] " + lib.escapeShellArgs [ # Allow updates triggered by SIGUSR2
				(lib.getExe pkgs.playerctl)
				"metadata"
				"--format"
				key
			];

			# Utility function to construct a control button label
			mkControlButton = xOffset: text: onClickSubcommand: {
				# Specify position
				position = "${toString xOffset}, -250";
				halign = "center";
				valign = "center";

				# Declare text style
				inherit text;
				color = "$text_color";
				font_family = "$font";
				font_size = 14;

				# Register the command to execute when the widget is clicked
				onclick = "${lib.getExe pkgs.playerctl} ${onClickSubcommand}";
			};
		in
		[
			# Display media title
			{
				# Specify position
				position = "100, -150";
				halign = "center";
				valign = "center";

				# Declare text style
				text = getMediaMetadata "\\{{ trunc(title, 23) }}"; # Get media title and truncate to 23 characters
				color = "$text_color";
				font_family = "$font";
				font_size = 14;
			}

			# Display media artist
			{
				# Specify position
				position = "100, -180";
				halign = "center";
				valign = "center";

				# Declare text style
				text = getMediaMetadata "\\{{ trunc(artist, 33) }}"; # Get media artist and truncate to 33 characters
				color = "$secondary_text_color";
				font_family = "$font";
				font_size = 10;
			}

			# Display media album
			{
				# Specify position
				position = "100, -205";
				halign = "center";
				valign = "center";

				# Declare text style
				text = getMediaMetadata "\\{{ trunc(album, 41) }}"; # Get media album and truncate to 41 characters
				color = "$secondary_text_color";
				font_family = "$font";
				font_size = 8;
			}

			# Display media position & length
			{
				# Specify position
				position = "0, -250";
				halign = "center";
				valign = "center";

				# Declare text style
				text = getMediaMetadata "\\{{ duration(position) }} / \\{{ duration(mpris:length) }}"; # Get media position & length
				color = "$secondary_text_color";
				font_family = "$font";
				font_size = 10;
			}

			# Display play/pause control button
			(let
				# Declare shell script to get the button icon
				getPlayPauseIcon = pkgs.writeShellApplication {
					name = "get-play-pause-icon";
					runtimeInputs = [ pkgs.playerctl ];
					text = lib.fileContents ./get-play-pause-icon.sh;
				};
			in
			# Switch button icon when Hyprlock recieved SIGUSR2
			mkControlButton 160 "cmd[update:0:true] ${lib.getExe getPlayPauseIcon}" "play-pause")

			# Display previous track control button
			(mkControlButton 90 "󰒮" "previous")

			# Display next track control button
			(mkControlButton 230 "󰒭" "next")

			# Display rewind 15 seconds control button
			(mkControlButton 125 "⟲" "position 15-")

			# Display skip 15 seconds control button
			(mkControlButton 195 "⟳" "position 15+")
		];
	};
}
