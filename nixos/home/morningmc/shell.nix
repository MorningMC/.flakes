{ config, pkgs, ... }: {
	# Enable Zsh shell
	programs.zsh.enable = true;

	# Set default shell to Zsh
	users.users.morningmc.shell = pkgs.zsh;
}
