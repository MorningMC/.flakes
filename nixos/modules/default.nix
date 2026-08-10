{ pkgs, ... }: {
	# Specify the Linux kernel used
	boot.kernelPackages = pkgs.linuxPackages_zen;

	# Enable SysRq functions
	boot.kernel.sysctl."kernel.sysrq" = true;

	nix.settings = {
		# Specify Nix experimental features
		experimental-features = [
			"nix-command" # Allow nix commands
			"flakes" # Enable flakes
		];

		# Optimise Nix store after building system
		auto-optimise-store = true;

		# Enable Noctalia Cachix cache
		extra-substituters = [ "https://noctalia.cachix.org" ];
		extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
	};

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.11"; # Did you read the comment?
}
