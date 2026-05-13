{ config, lib, pkgs, ... }: {
	home-manager.users.morningmc = {
		# Enable mpvpaper
		programs.mpvpaper.enable = true;

		# Declare Systemd service to manage mpvpaper
		systemd.user.services.mpvpaper = let
			wallpaperPath = "${config.users.users.morningmc.home}/Pictures/Saved/desktop/nighttime.mp4"; # Declare wallpaper path
			sessionTarget = [ config.home-manager.users.morningmc.wayland.systemd.target ]; # Specify required graphical session target
		in
		{
			Unit = {
				Description = "mpvpaper wallpaper daemon";
				Documentation = [ "man:mpvpaper(1)" ];
				After = sessionTarget; # Run only when specified target is active
			};

			Service = {
				# Command executed on service start
				ExecStart = lib.escapeShellArgs [
					"${pkgs.mpvpaper}/bin/mpvpaper"
					"--auto-pause" # Automatically pause MPV when the wallpaper is hidden
					"--mpv-options"
					"no-audio loop panscan=1.0"
					"ALL" # Play the video on all outputs
					wallpaperPath
				];

				# Automatically restart when process ends or hits run time limit
				Restart = "always";

				# Limit run time to prevent memory leak
				RuntimeMaxSec = 1800; # 30 mins
			};

			# Run automatically after specified target hits
			Install.WantedBy = sessionTarget;
		};
	};
}
