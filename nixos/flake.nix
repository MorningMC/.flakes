{
	description = "NixOS System Flake";
	
	# Declare external dependencies
	inputs = {
		# The Nixpkgs channel used
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		# Use import-tree to recursively import Nix files
		import-tree.url = "github:denful/import-tree";

		# Use Home Manager to manage home directories
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Use agenix to encrypt secrets in flake
		agenix = {
			url = "github:ryantm/agenix";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
			inputs.darwin.follows = ""; # Not to download darwin dependencies
		};

		# Use nix-flatpak to manage Flatpak declaratively
		nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest"; # nix-flatpak does not use any input

		# Use nix-index-database to enable comma and its required database
		nix-index-database = {
			url = "github:nix-community/nix-index-database";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Use Quickshell derivation flake as Quickshell is outdated in Nixpkgs
		quickshell = {
			url = "path:../quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Fetch Ly blackhole background
		ly-blackhole = {
			url = "https://codeberg.org/attachments/f336d6ac-8331-4323-91fc-0e4619803401";
			flake = false;
		};
	};
	
	# Declare complete sets of NixOS configurations
	outputs = inputs: {
		# Configure system for morningmc-laptop
		nixosConfigurations.morningmc-laptop = inputs.nixpkgs.lib.nixosSystem {
			# Declare arguments passed to modules
			specialArgs = {
				inherit inputs;

				# Specify current flake's path on filesystem
				flake = "/home/morningmc/.flakes/nixos";
			};

			# Declare modules to include
			modules = [
				(inputs.import-tree ./modules) # Import global modules
				(inputs.import-tree ./hosts/morningmc-laptop) # Import host configurations
				(inputs.import-tree ./home/morningmc) # Import user configurations
			];
		};
	};
}
