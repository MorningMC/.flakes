{
	description = "Pixel-accurate and complete TrueType fonts from Minecraft: Java Edition";

	# Declare external dependencies
	inputs = {
		# The Nixpkgs channel used
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		# Distributed framework for writing Nix flakes
		flake-parts.url = "github:hercules-ci/flake-parts";

		# Declare upstream repository
		minecraft-ttf = {
			url = "github:tryashtar/minecraft-ttf";
			flake = false; # The repository does not contain a flake.nix
		};

		# Menifest of Minecraft: Java Edition's versions
		version-menifest = {
			url = "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json";
			flake = false;
		};

		# The Adobe Glyph List used by the source code
		agl-aglfn = {
			url = "github:adobe-type-tools/agl-aglfn";
			flake = false; # The repository does not contain a flake.nix
		};
	};

	# Declare the outputs
	outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
		# Declare architectures to generate outputs for
		systems = inputs.nixpkgs.lib.systems.flakeExposed; # Build for all supported architectures

		# Generate flake for every architecture in systems
		perSystem = { system, pkgs, ... }: {
			# Override the pkgs argument to inject custom Nixpkgs configuration
			_module.args.pkgs = import inputs.nixpkgs {
				inherit system;

				# Allow building derivations with unfree licenses
				config.allowUnfree = true;
			};

			# Pass inputs to the derivation
			packages.default = pkgs.callPackage ./default.nix { inherit (inputs) minecraft-ttf version-menifest agl-aglfn; };
		};
	};
}
