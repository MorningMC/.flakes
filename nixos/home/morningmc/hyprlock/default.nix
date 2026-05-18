{ config, lib, pkgs, ... }: {
	imports = [
		./settings.nix
	];

	home-manager.users.morningmc = {
		# Enable Hyprlock
		programs.hyprlock.enable = true;

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
