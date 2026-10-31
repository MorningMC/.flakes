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
        agenix.inputs.nixpkgs.follows = "nixpkgs";

        # Declarative Flatpak manager for NixOS
        nix-flatpak.url = "github:gmodena/nix-flatpak/latest"; # nix-flatpak does not use any input

        # Package and manage Minecraft servers declaratively
        nix-minecraft.url = "github:Infinidoge/nix-minecraft";
        nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";

        # NixOS module for Playit Agent
        playit-nixos-module.url = "github:pedorich-n/playit-nixos-module";
        playit-nixos-module.inputs.nixpkgs.follows = "nixpkgs";

        # nix-index database with comma and integration with command-not-found
        nix-index-database.url = "github:nix-community/nix-index-database";
        nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

        # Nix flake port of tryashtar/minecraft-ttf
        minecraft-ttf.url = "path:../minecraft-ttf";
        minecraft-ttf.inputs.nixpkgs.follows = "nixpkgs";

        # A stylish Zsh theme with deliberate use of space
        headline.url = "github:Moarram/headline";
        headline.flake = false; # The repository does not contain a flake.nix

        # A lua package for Hyprland to provide awesome/dwm-like behavior with workspaces
        split-monitor-workspaces.url = "github:zjeffer/split-monitor-workspaces";
        split-monitor-workspaces.flake = false; # Only Lua scripts are used. We don't need an entire flake.
    };

    # Declare complete sets of NixOS configurations
    outputs = { nixpkgs, import-tree, ... }@inputs: {
        # Configure system for morningmc-laptop
        nixosConfigurations.morningmc-laptop = nixpkgs.lib.nixosSystem {
            # Pass flake inputs to modules
            specialArgs.inputs = inputs;

            # Declare modules to include
            modules = [
                (import-tree ./modules) # Import global modules
                (import-tree ./hosts/morningmc-laptop) # Import host configurations
                (import-tree ./home/morningmc+morningmc-laptop) # Import user configurations
            ];
        };

        # Configure system for adventurers-server
        nixosConfigurations.adventurers-server = nixpkgs.lib.nixosSystem {
            # Pass flake inputs to modules
            specialArgs.inputs = inputs;

            # Declare modules to include
            modules = [
                (import-tree ./modules) # Import global modules
                (import-tree ./hosts/adventurers-server) # Import host configurations
                (import-tree ./home/morningmc+adventurers-server) # Import user configurations
            ];
        };
    };
}
