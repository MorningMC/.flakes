{ config, lib, pkgs, ... }: {
    # Enable hardware acceleration for 32-bit applications on supported systems
    hardware.graphics.enable32Bit = pkgs.stdenv.hostPlatform.isx86_64 && (config.boot.kernelPackages.kernel.features.ia32Emulation or false);

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

        # Enable PRIME render offload support if hardware acceleration is enabled. PCI addresses is declared in specific host configurations.
        prime.offload = {
            enable = config.hardware.graphics.enable;

            # Add a convenience script for offloading programs to an NVIDIA device
            enableOffloadCmd = config.hardware.nvidia.prime.offload.enable;
            offloadCmdMainProgram = "prime-run"; # Follows conventional name
        };
    };

    # Move CUDA caches to temporary filesystem
    environment.sessionVariables.CUDA_CACHE_PATH = lib.mkIf config.hardware.nvidia.enabled "$XDG_RUNTIME_DIR/nvidia/ComputeCache";
}
