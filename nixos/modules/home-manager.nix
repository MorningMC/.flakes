{ inputs, ... }: {
	# Import Home Manager module
	imports = [ inputs.home-manager.nixosModules.default ];

	# Install home.packages to /etc/profiles
	home-manager.useUserPackages = true;

	# Inherit global Nixpkgs settings
	home-manager.useGlobalPkgs = true;
}
