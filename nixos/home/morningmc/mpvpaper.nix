{ config, lib, pkgs, ... }: {
	# Enable mpvpaper & register as a Systemd service
	home-manager.users.morningmc.systemd.user.services.mpvpaper = let
		homeConfig = config.home-manager.users.morningmc;

		# Declare wallpaper path
		wallpaperPath = "${homeConfig.xdg.userDirs.pictures}/Saved/desktop/nighttime.mp4";

		# Specify required graphical session target
		sessionTarget = [ homeConfig.wayland.systemd.target ];
	in
	{
		Unit = {
			Description = "mpvpaper wallpaper daemon";
			Documentation = [ "man:mpvpaper(1)" ];

			# Run only when specified target is active
			BindsTo = sessionTarget;
			After = sessionTarget;
		};

		Service = {
			# Command executed on service start
			ExecStart = lib.escapeShellArgs [
				(lib.getExe pkgs.mpvpaper)
				"--auto-pause" # Automatically pause MPV when the wallpaper is hidden
				"--mpv-options"
				"no-audio loop panscan=1.0 --quiet"
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
}
