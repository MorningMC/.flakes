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

		# Use nix-flatpak to manage Flatpak declaratively
		nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest"; # nix-flatpak does not use any input

		# Use Quickshell derivation flake as Quickshell is outdated in Nixpkgs
		quickshell = {
			url = "path:../quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	
	# Declare complete sets of NixOS configurations
	outputs = { self, nixpkgs, home-manager, nix-flatpak, quickshell, ... }: {

		# Configure system for morningmc-laptop
		nixosConfigurations.morningmc-laptop = let
			system = "x86_64-linux"; # Declare hardware architecture
			flake = "/home/morningmc/.flakes/nixos"; # Specify current flake's path
		in
		nixpkgs.lib.nixosSystem {
			inherit system;

			# Declare arguments passed to modules
			specialArgs = { inherit system flake quickshell; };

			modules = [
				# Import Home Manager module
				home-manager.nixosModules.default

				# Import nix-flatpak module
				nix-flatpak.nixosModules.nix-flatpak

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
