{ config, pkgs, ... }: {
	home-manager.users.morningmc.programs = {
		# Enable Git
		git = {
			enable = true;
			lfs.enable = true; # Enable Large File Support

			# Manage Git config with Home Manager
			settings = {
				user.name = "MorningMC";
				user.email = "github@momc.qzz.io";

				core.hooksPath = "/home/morningmc/.config/scripts/githooks";
				credential.helper = "/usr/lib/git-core/git-credential-libsecret";
				init.defaultBranch = "main";
				pull.rebase = false;
			};
		};

		# Enable LazyGit
		lazygit.enable = true;
	};

	# Enable commitlint
	users.users.morningmc.packages = with pkgs; [ commitlint ];
}
