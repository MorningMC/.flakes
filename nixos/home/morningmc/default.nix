{ config, pkgs, ... }: {
	imports = [
		./packages.nix
		./flatpak.nix
		./desktop.nix
		./git.nix
		./docker.nix
		./easytier.nix
		./mpd.nix
		./fcitx.nix
		./fonts.nix
	];

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.morningmc = {
		isNormalUser = true;
		description = "MorningMC";
		extraGroups = [ "networkmanager" "wheel" ];
	};
	
	home-manager.users.morningmc = {
		# Let Home Manager install and manage itself.
		programs.home-manager.enable = true;

		# Enable XDG user directories
		xdg.userDirs = {
			enable = true;

			# Export environment variables to session
			setSessionVariables = true;

			# Disable unused directories
			desktop = null;
			publicShare = null;

			# Add custom directories
			extraConfig.WORKSPACES = "${config.users.users.morningmc.home}/Workspaces";
		};
		
		# This value determines the Home Manager release that your configuration is
		# compatible with. This helps avoid breakage when a new Home Manager release
		# introduces backwards incompatible changes.
		#
		# You should not change this value, even if you update Home Manager. If you do
		# want to update the value, then make sure to first check the Home Manager
		# release notes.
		home.stateVersion = "25.11"; # Did you read the comment?
	};
}
