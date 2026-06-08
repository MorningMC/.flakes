{ config, pkgs, ... }: {
	users.users.morningmc.packages = with pkgs; [
		ffmpeg # Video / audio codec
		yt-dlp # Video downloader
		cava # Audio Visualizer
		haruna # Media player
		rmpc # MPD client

		# Controllers
		pwvucontrol # Volume controller
		crosspipe # PipeWire device controller
	];

	home-manager.users.morningmc.services = {
		# Enable Music Player Daemon
		mpd = let
			inherit (config.home-manager.users.morningmc.services.mpd) musicDirectory dataDir;
		in
		{
			enable = true;
			network.startWhenNeeded = true; # Activate through socket

			# Declare playlist directory
			playlistDirectory = musicDirectory + "/Playlists";

			# Configure audio output & state file
			extraConfig = ''
				state_file "${dataDir}/state"

				audio_output {
					type "pulse"
					name "Pulse Audio"
				}

				audio_output {
					type "fifo"
					name "my_fifo"
					path "$XDG_RUNTIME_DIR/mpd/fifo"
					format "44100:16:2"
				}
			'';
		};

		# Make MPD and other MPRIS controller compatible
		mpd-mpris.enable = true;

		# Enable MPRIS media player daemon
		playerctld.enable = true;
	};
}
