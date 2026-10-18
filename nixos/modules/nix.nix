{ config, lib, pkgs, ... }: {
    # Use Lix as the Nix implementation
    nix.package = pkgs.lixPackageSets.latest.lix;

    # Rewire other tools that depend on Nix to ensure consistency
    nixpkgs.overlays = [
        (final: prev: {
            inherit (prev.lixPackageSets.latest)
                nixpkgs-review
                nix-eval-jobs
                nix-fast-build
                colmena;
        })
    ];

    # Configure Nix
    nix.settings = lib.mkMerge [
        {
            # Specify Nix experimental features
            experimental-features = [ "nix-command" "flakes" ];

            # Make users in wheel group trusted by Nix
            trusted-users = [ "@wheel" ];

            # Optimise Nix store after building system
            auto-optimise-store = true;

            # Allow remote builders to use caches
            builders-use-substitutes = true;

            # Declare mirrors of the NixOS cache
            substituters = [
                "https://mirrors.cernet.edu.cn/nix-channels/store" # CERNET MirrorZ 302 Service
            ];
        }

        # Enable CUDA caches if CUDA support is enabled
        (lib.mkIf config.nixpkgs.config.cudaSupport {
            substituters = [
                "https://cache.flox.dev" # Flox CUDA Binary Cache
                "https://cache.nixos-cuda.org" # Nix Community CUDA Cache
            ];

            trusted-public-keys = [
                "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
                "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
            ];
        })
    ];

    # Prevent large Nix builds consuming all memories
    systemd.services.nix-daemon.serviceConfig.MemoryHigh = "80%";
}
