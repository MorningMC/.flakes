{ config, lib, pkgs, ... }: {
    # Enable hardware acceleration for 32-bit applications on supported systems by default
    hardware.graphics.enable32Bit = lib.mkDefault (
        pkgs.stdenv.hostPlatform.isx86_64 # On an x86_64 system
        && (config.boot.kernelPackages.kernel.features.ia32Emulation or false) # The kernel supports 32-bit emulation
    );

    # Configure NVIDIA driver on-demand (enabled in host-specific configurations)
    hardware.nvidia = {
        # Use open-source kernel module
        open = true;

        # Use the latest branch of NVIDIA drivers
        branch = "latest";

        # Enable kernel modesetting
        modesetting.enable = true;

        # Enable power management through systemd
        powerManagement.enable = true;
        powerManagement.finegrained = config.hardware.nvidia.prime.offload.enable; # Enable for PRIME offload

        # Add a convenience script for offloading programs to an NVIDIA device if PRIME offload is enabled
        prime.offload.enableOffloadCmd = config.hardware.nvidia.prime.offload.enable;
        prime.offload.offloadCmdMainProgram = "prime-run"; # Follows conventional name
    };

    # Configure environment variables for NVIDIA drivers
    environment.sessionVariables = lib.mkIf config.hardware.nvidia.enabled {
        # Configure NVIDIA VA-API driver to interface directly with the kernel driver backend
        NVD_BACKEND = "direct";

        # Move CUDA caches to temporary filesystem
        CUDA_CACHE_PATH = "$XDG_RUNTIME_DIR/nvidia/ComputeCache";
    };
}
