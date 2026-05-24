{ config, lib, pkgs, ... }: {
	# Declare media widgets in Hyprlock configurations
	home-manager.users.morningmc.programs.hyprlock.settings = {
		# Display media album art
		image = let
			# Declare where to store the album art
			path = "/tmp/hyprlock-album-art.png";

			# Declare shell script to fetch media album art image
			fetchAlbumArt = pkgs.writeShellApplication {
				name = "fetch-album-art";
				runtimeInputs = [ pkgs.curl pkgs.playerctl ];
				text = lib.fileContents ./fetch-album-art.sh;
			};
		in
		{
			# Specify position and size
			position = "-200, -200";
			size = 150;
			halign = "center";
			valign = "center";

			# Specify image path
			inherit path;
			reload_cmd = lib.escapeShellArgs [ (lib.getExe fetchAlbumArt) path ];
			reload_time = 0; # Reload when Hyprlock recieved SIGUSR2 update

			# Declare image style
			rounding = 5;
			border_size = 0;

			# Register the command to execute when the widget is clicked
			onclick = "pkill -SIGUSR2 hyprlock"; # Click the album art to trigger a manual update
		};

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
				# Specify position and size
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
				# Specify position and size
				position = "100, -150";
				halign = "center";
				valign = "center";

				# Declare text style
				text = getMediaMetadata "\\{{ title }}"; # Get media title every 5 seconds
				color = "$text_color";
				font_family = "$font";
				font_size = 14;
			}

			# Display media artist
			{
				# Specify position and size
				position = "100, -180";
				halign = "center";
				valign = "center";

				# Declare text style
				text = getMediaMetadata "\\{{ artist }}"; # Get media artist every 5 seconds
				color = "$secondary_text_color";
				font_family = "$font";
				font_size = 10;
			}

			# Display media album
			{
				# Specify position and size
				position = "100, -205";
				halign = "center";
				valign = "center";

				# Declare text style
				text = getMediaMetadata "\\{{ album }}"; # Get media album every 5 seconds
				color = "$secondary_text_color";
				font_family = "$font";
				font_size = 8;
			}

			# Display media position & length
			{
				# Specify position and size
				position = "0, -250";
				halign = "center";
				valign = "center";

				# Declare text style
				# Get media position & length every second
				text = getMediaMetadata "\\{{ duration(position) }} / \\{{ duration(mpris:length) }}";
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
