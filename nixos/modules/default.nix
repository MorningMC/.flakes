{ pkgs, inputs, ... }: {
	# Specify the Linux kernel used
	boot.kernelPackages = pkgs.linuxPackages_zen;

	# Enable SysRq functions
	boot.kernel.sysctl."kernel.sysrq" = true;

	# Import agenix NixOS module for secret encryption
	imports = [ inputs.agenix.nixosModules.default ];

	# Declare path to host recipient keys
	age.identityPaths = [ "/var/lib/agenix/host_age_pq_key" ];

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.11"; # Did you read the comment?
}
