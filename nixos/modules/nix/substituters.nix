{ config, lib, ... }: {
    # Configure Nix binary caches
    nix.settings = lib.mkMerge [
        {
            substituters = [
                # Declare mirrors of the NixOS cache
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

        # Enable nix-cachyos-kernel binary cache if CachyOS kernel is being used
        (lib.mkIf (lib.hasInfix "cachyos" config.boot.kernelPackages.kernel.pname) {
            substituters = [ "https://cache.lantian.pub/lantian" ];
            trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" ];
        })
    ];
}
