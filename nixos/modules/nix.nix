{ config, lib, pkgs, ... }: {
    # Declare encrypted secrets used
    age.secrets.builder-qqxnkrut.file = ./_secrets/builder-qqxnkrut.pem.age;

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
        }

        # Enable CUDA caches if CUDA support is enabled
        (lib.mkIf config.nixpkgs.config.cudaSupport {
            substituters = [
                "https://cache.nixos-cuda.org" # Nix Community CUDA Cache
                "https://cache.flox.dev" # Flox CUDA Binary Cache
            ];

            trusted-public-keys = [
                "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
                "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
            ];
        })
    ];

    # Prevent large Nix builds consuming all memories
    systemd.services.nix-daemon.serviceConfig.MemoryHigh = "80%";
}
