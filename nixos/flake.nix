{
	description = "NixOS System Flake";
	
	# Declare external dependencies
	inputs = {
		# The Nixpkgs channel used
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		
		# Use Home Manager to manage home directories
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Use Quickshell derivation flake as Quickshell is outdated in Nixpkgs
		quickshell = {
			url = "path:../quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	
	# Declare complete sets of NixOS configurations
	outputs = { self, nixpkgs, home-manager, quickshell, ... }: {

		# Configure system for morningmc-laptop
		nixosConfigurations.morningmc-laptop = let
			# Declare hardware architecture
			system = "x86_64-linux";

			# Specify current flake's path
			flake = "/home/morningmc/.flakes/nixos";
		in
		nixpkgs.lib.nixosSystem {
			inherit system;

			# Declare arguments passed to modules
			specialArgs = { inherit system flake quickshell; };

			modules = [
				# Import Home Manager module
				home-manager.nixosModules.default

				# Import global modules
				./modules

				# Import host configurations
				./hosts/morningmc-laptop

				# Import user configurations
				./home/morningmc
			];
		};
	};
}
