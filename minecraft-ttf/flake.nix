{
    description = "Nix flake port of tryashtar/minecraft-ttf";

    # Declare external dependencies
    inputs = {
        # The Nixpkgs channel used
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        # Distributed framework for writing Nix flakes
        flake-parts.url = "github:hercules-ci/flake-parts";

        # Declare upstream repository
        minecraft-ttf.url = "github:tryashtar/minecraft-ttf";
        minecraft-ttf.flake = false; # The repository does not contain a flake.nix

        # Menifest of Minecraft: Java Edition's versions
        version-menifest.url = "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json";
        version-menifest.flake = false;
    };

    # Declare the outputs
    outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
        # Declare architectures to generate outputs for
        systems = inputs.nixpkgs.lib.systems.flakeExposed; # Build for all supported architectures

        # Generate flake for every architecture in systems
        perSystem = { self', system, pkgs, ... }: {
            # Override the pkgs argument to inject custom Nixpkgs configuration
            _module.args.pkgs = import inputs.nixpkgs {
                inherit system;

                # Allow building derivations with unfree licenses
                config.allowUnfree = true;
            };

            packages = {
                # Specify the default package to build
                default = self'.packages.minecraft-ttf;

                # The compiled binary of the source code
                minecraft-ttf-bin = pkgs.callPackage ./binary.nix { inherit (inputs) minecraft-ttf; };

                # The cache derivation fed to the binary
                minecraft-ttf-cache = pkgs.callPackage ./cache.nix { inherit (inputs) version-menifest; };

                # The generated font product
                minecraft-ttf = pkgs.callPackage ./default.nix { inherit (self'.packages) minecraft-ttf-bin minecraft-ttf-cache; };
            };
        };
    };
}
