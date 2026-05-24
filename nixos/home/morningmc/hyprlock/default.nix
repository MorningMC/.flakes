{ config, lib, pkgs, ... }: {
	imports = [
		./settings.nix
		./media.nix
	];

	home-manager.users.morningmc = {
		# Enable Hyprlock
		programs.hyprlock.enable = true;

		systemd.user.services = {
			# Register Hyprlock as a Systemd service
			hyprlock = let
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

			# Register a deamon service to update Hyprlock when media matadata is changed
			hyprlock-media-updater = let
				# Specify required Hyprlock service
				lockscreenTarget = [ "hyprlock.service" ];

				# Declare the shell script to execute
				script = pkgs.writeShellApplication {
					name = "hyprlock-media-updater";
					runtimeInputs = [ pkgs.playerctl ];
					text = lib.fileContents ./hyprlock-media-updater.sh;
				};
			in
			{
				Unit = {
					Description = "Hyprlock media updater daemon";
					Documentation = [ "man:playerctl(1)" ];

					# Run only when specified target is active
					BindsTo = lockscreenTarget;
					After = lockscreenTarget;
				};

				Service = {
					# Command executed on service start
					ExecStart = lib.getExe script;

					# Restart service on failure
					Restart = "on-failure";
				};

				# Run automatically after specified target hits
				Install.WantedBy = lockscreenTarget;
			};
		};
	};

	# Enable PAM module to perform authentication
	security.pam.services.hyprlock = { };
}
