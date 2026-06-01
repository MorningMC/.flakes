{ inputs, ... }: {
	# Import Home Manager module
	imports = [ inputs.home-manager.nixosModules.default ];

	# Make user settings fully declarative
	users.mutableUsers = false;

	# Install Home Manager home.packages to /etc/profiles
	home-manager.useUserPackages = true;

	# Inherit Home Manager Nixpkgs settings from global Nixpkgs
	home-manager.useGlobalPkgs = true;

	# Allow passwordless wheel group
	security.sudo.wheelNeedsPassword = false;
}
