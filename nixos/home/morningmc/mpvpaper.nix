{ config, lib, pkgs, ... }: {
	home-manager.users.morningmc = {
		# Enable mpvpaper
		programs.mpvpaper.enable = true;

		# Register mpvpaper as Systemd services
		systemd.user.services = let
			# Declare wallpaper path
			wallpaperPath = "${config.users.users.morningmc.home}/Pictures/Saved/desktop/nighttime.mp4";

			# Specify required graphical session target
			sessionTarget = [ config.home-manager.users.morningmc.wayland.systemd.target ];

			# Specify required lockscreen target
			lockTarget = [ "hyprlock.service" ];
		in
		{
			# Desktop wallpaper service
			mpvpaper = {
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

			# Lockscreen wallpaper service
			mpvpaper-lockscreen = {
				Unit = {
					Description = "mpvpaper wallpaper daemon on lockscreen";
					Documentation = [ "man:mpvpaper(1)" ];

					# Run only when specified target is active
					BindsTo = lockTarget;
					After =	lockTarget;
				};

				Service = {
					# Command executed on service start
					ExecStart = lib.escapeShellArgs [
						(lib.getExe pkgs.mpvpaper)
						"--auto-pause" # Automatically pause MPV when the wallpaper is hidden
						"--layer"
						"overlay" # Play the video above all windows
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
				Install.WantedBy = lockTarget;
			};
		};
	};
}
