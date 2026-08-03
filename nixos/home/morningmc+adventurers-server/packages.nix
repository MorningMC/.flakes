{ flake, ... }: {
	# Enable OpenSSH daemon
	services.openssh.enable = true;

	# Enable NH command helper
	programs.nh = {
		enable = true;
		inherit flake; # Use current flake

		# Setup garbage cleaner (this makes nix.gc obsolete)
		clean = {
			enable = true;

			# Perform a clean every day
			dates = "daily";

			# Options given to nh clean
			extraArgs = "--keep 3 --keep-since 7d";
		};
	};

	# Enable Git
	home-manager.users.morningmc.programs.git = {
		enable = true;
		lfs.enable = true; # Enable Large File Support

		# Manage Git config with Home Manager
		settings = {
			user.name = "MorningMC";
			user.email = "github@momc.qzz.io";

			init.defaultBranch = "main";
			pull.rebase = false;
		};
	};
}
