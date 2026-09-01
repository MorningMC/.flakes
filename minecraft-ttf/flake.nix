{
    description = "Nix flake port of tryashtar/minecraft-ttf";

    # Declare external dependencies
    inputs = {
        # The Nixpkgs channel used
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        # Distributed framework for writing Nix flakes
        flake-parts.url = "github:hercules-ci/flake-parts";

        # Nix tooling for Python projects & metadata
        pyproject-nix.url = "github:pyproject-nix/pyproject.nix";
        pyproject-nix.inputs.nixpkgs.follows = "nixpkgs";

        # Build Python environment from uv.lock
        uv2nix = {
            url = "github:pyproject-nix/uv2nix";
            inputs.pyproject-nix.follows = "pyproject-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Declare upstream repository
        minecraft-ttf.url = "github:tryashtar/minecraft-ttf";
        minecraft-ttf.flake = false; # The repository does not contain a flake.nix

        # Menifest of Minecraft: Java Edition's versions
        version-menifest.url = "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json";
        version-menifest.flake = false;

        # The Adobe Glyph List used by the source code
        agl-aglfn.url = "github:adobe-type-tools/agl-aglfn";
        agl-aglfn.flake = false; # The repository does not contain a flake.nix
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

            # Expose the Python build environment
            packages.pythonBuildEnv = pkgs.callPackage ./python.nix { inherit (inputs) pyproject-nix uv2nix minecraft-ttf; };

            # Pass inputs to the derivation
            packages.default = pkgs.callPackage ./default.nix {
                inherit (inputs) minecraft-ttf version-menifest agl-aglfn;
                inherit (self'.packages) pythonBuildEnv;
            };
        };
    };
}
