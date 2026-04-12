{
	description = "Quickshell bundled Qt deps for home-manager usage";

	# Declare external dependencies
	inputs = {
		# The Nixpkgs channel used
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		
		# Quickshell in Nixpkgs is outdated. Use flake from git repository.
		quickshell = {
			url = "git+https://git.outfoxxed.me/quickshell/quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Import end-4's dots-hyprland as build script
		dots-hyprland = {
			url = "github:end-4/dots-hyprland";
			flake = false; # Only quickshell.nix is used. We don't need a entire flake.
		};
	};

	# Declare the outputs
	outputs = { self, nixpkgs, quickshell, dots-hyprland, ... }: let
		# Declare hardware architecture
		system = "x86_64-linux";

		pkgs = nixpkgs.legacyPackages.${system};
	in
	{
		# Use package defined in default.nix
		packages.${system}.default = pkgs.callPackage ./default.nix {
			# Pass build script
			script = import "${dots-hyprland}/sdata/dist-nix/home-manager/quickshell.nix";

			# Pass Quickshell package to default.nix as a dependency
			inherit quickshell;
		};
	};
}
