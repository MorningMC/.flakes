{
	description = "Quickshell bundled Qt deps for home-manager usage";

	# Declare external dependencies
	inputs = {
		# The Nixpkgs channel used
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		# Distributed framework for writing Nix flakes
		flake-parts.url = "github:hercules-ci/flake-parts";
		
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
	outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
		# Declare architectures to generate outputs for
		systems = [ "x86_64-linux" ]; # Only generate for x86_64-linux as this is hardcoded to dots-hyprland script

		# Generate flake for every architecture in systems
		perSystem = { pkgs, ... }: let
			script = import "${inputs.dots-hyprland}/sdata/dist-nix/home-manager/quickshell.nix";
		in
		{
			# Use package defined in dots-hyprland & pass Quickshell package as a dependency
			packages.default = pkgs.callPackage script { inherit (inputs) quickshell; };
		};
	};
}
