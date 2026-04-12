{ config, pkgs, ... }:

{
	# Enable Git
	programs.git = {
		enable = true;
		lfs.enable = true; # Enable Large File Support
	};
	
	# Enable LazyGit
	programs.lazygit.enable = true;

	# Enable commitlint
	users.users.morningmc.packages = with pkgs; [ commitlint ];
	
	# Manage Git config with Home Manager
	home-manager.users.morningmc.programs.git = {
		enable = true;
		lfs.enable = true;
		
		settings = {
			user.name = "MorningMC";
			user.email = "github@momc.qzz.io";
			
			core.hooksPath = "/home/morningmc/.config/scripts/githooks";
			credential.helper = "/usr/lib/git-core/git-credential-libsecret";
			init.defaultBranch = "main";
			pull.rebase = false;
		};
	};
}
