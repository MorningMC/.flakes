{
    description = "NixOS System Flake";

    # Declare external dependencies
    inputs = {
        # The Nixpkgs channel used
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        # Recursively import Nix modules from a directory
        import-tree.url = "github:denful/import-tree"; # import-tree does not use any input

        # Basic system for managing a user environment
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # age-encrypted secrets for NixOS and Home manager
        agenix.url = "github:ryantm/agenix";
        agenix.inputs = {
            nixpkgs.follows = "nixpkgs";
            home-manager.follows = "home-manager";
            darwin.follows = ""; # Not to download darwin dependencies
        };

        # Declarative Flatpak manager for NixOS
        nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest"; # nix-flatpak does not use any input

        # Package and manage Minecraft servers declaratively
        nix-minecraft.url = "github:Infinidoge/nix-minecraft";
        nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";

        # nix-index database with comma and integration with command-not-found
        nix-index-database.url = "github:nix-community/nix-index-database";
        nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

        # ESP8266 and ESP32 packages and development environments for Nix
        nixpkgs-esp-dev.url = "github:mirrexagon/nixpkgs-esp-dev"; # Overriding nixpkgs input will cause python3.13-ecdsa fail to build

        # Nix flake port of tryashtar/minecraft-ttf
        minecraft-ttf.url = "path:../minecraft-ttf";
        minecraft-ttf.inputs.nixpkgs.follows = "nixpkgs";

        # A stylish Zsh theme with deliberate use of space
        headline.url = "github:Moarram/headline";
        headline.flake = false; # The repository does not contain a flake.nix
    };

    # Declare complete sets of NixOS configurations
    outputs = inputs: {
        # Configure system for morningmc-laptop
        nixosConfigurations.morningmc-laptop = inputs.nixpkgs.lib.nixosSystem {
            # Pass flake inputs to modules
            specialArgs.inputs = inputs;

            # Specify current flake's path on filesystem
            specialArgs.flake = "/home/morningmc/.flakes/nixos";

            # Declare modules to include
            modules = [
                (inputs.import-tree ./modules) # Import global modules
                (inputs.import-tree ./hosts/morningmc-laptop) # Import host configurations
                (inputs.import-tree ./home/morningmc+morningmc-laptop) # Import user configurations
            ];
        };

        # Configure system for adventurers-server
        nixosConfigurations.adventurers-server = inputs.nixpkgs.lib.nixosSystem {
            # Pass flake inputs to modules
            specialArgs.inputs = inputs;

            # Specify current flake's path on filesystem
            specialArgs.flake = "/home/morningmc/.flakes/nixos";

            # Declare modules to include
            modules = [
                (inputs.import-tree ./modules) # Import global modules
                (inputs.import-tree ./hosts/adventurers-server) # Import host configurations
                (inputs.import-tree ./home/morningmc+adventurers-server) # Import user configurations
            ];
        };
    };
}
