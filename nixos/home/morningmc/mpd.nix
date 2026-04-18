{ config, pkgs, ... }: {
	home-manager.users.morningmc.services = {
		# Enable Music Player Daemon
		mpd = {
			enable = true;
			network.startWhenNeeded = true; # Activate through socket

			# Declare playlist directory
			playlistDirectory = "${config.home-manager.users.morningmc.services.mpd.musicDirectory}/Playlists";

			# Configure audio output & state file
			extraConfig = ''
				state_file "${config.home-manager.users.morningmc.services.mpd.dataDir}/state"

				audio_output {
					type "pulse"
					name "Pulse Audio"
				}

				audio_output {
					type   "fifo"
					name   "my_fifo"
					path   "$XDG_RUNTIME_DIR/mpd/fifo"
					format "44100:16:2"
				}
			'';
		};

		# Make MPD and other MPRIS controller compatible
		mpd-mpris.enable = true;
	};

	# Enable RMPC (MPD client)
	users.users.morningmc.packages = with pkgs; [ rmpc ];
}
