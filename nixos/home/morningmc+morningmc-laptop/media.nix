{ pkgs, ... }: {
    users.users.morningmc.packages = with pkgs; [
        ffmpeg # Video / audio codec
        haruna # Media player

        # Controllers
        pwvucontrol # Volume controller
        crosspipe # PipeWire device controller
        playerctl # MPRIS CLI controller
    ];

    home-manager.users.morningmc = { config, ... }: {
        services = {
            # Enable Music Player Daemon
            mpd = {
                enable = true;
                network.startWhenNeeded = true; # Activate through socket

                # Declare playlist directory
                playlistDirectory = config.services.mpd.musicDirectory + "/Playlists";

                # Configure audio output & state file
                extraConfig = ''
                    state_file "${config.services.mpd.dataDir}/state"

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

        programs = {
            # Enable RMPC
            rmpc.enable = true;

            # Enable Cava audio visualizer
            cava.enable = true;

            # Enable yt-dlp
            yt-dlp.enable = true;
        };
    };
}
