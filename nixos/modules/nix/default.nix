{ lib, ... }: {
    nix = {
        # Configure Nix
        settings = {
            # Specify Nix experimental features
            experimental-features = [ "nix-command" "flakes" ];

            # Optimise Nix store after building system
            auto-optimise-store = true;

            # Allow remote builders to use caches
            builders-use-substitutes = true;

            # Fall back to local build if downloading a derivation from substituters fails
            fallback = true;
        };

        # Configure Nix store garbage collector
        gc = {
            # Automatically run the garbage collector periodically
            automatic = lib.mkDefault true;

            # Perform a clean every week
            dates = "weekly";

            # Keep generations younger than half a month
            options = "--delete-older-than 15d";
        };

        # Remove legacy Nix channel management. This flake already handles dependency resolution, locking, and inputs
        # explicitly.
        channel.enable = false;
    };

    # Prevent large Nix builds consuming all memories
    systemd.services.nix-daemon.serviceConfig.MemoryHigh = "80%";
}
