{ lib, pkgs, ... }: let
    # Import helper functions
    toNixPci = import ../../lib/to-nix-pci.nix { inherit lib; };

    # Declare PCI addresses for graphics cards
    integratedCardPci = "0000:00:02.0";
    discreteCardPci = "0000:02:00.0";
in
{
    # Declare video drivers
    services.xserver.videoDrivers = [ "nvidia" ];

    # Enable Intel graphics drivers
    hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver # VA-API media driver
        intel-compute-runtime # OpenCL & Level Zero compute runtime
        vpl-gpu-rt # Intel VPL GPU Runtime
    ];
    hardware.graphics.extraPackages32 = with pkgs.driversi686Linux; [
        intel-media-driver # 32-bit VA-API media driver
    ];

    # Enable PRIME render offload support
    hardware.nvidia.prime = {
        offload.enable = true;

        # Specify Intel & NVIDIA PCI address
        intelBusId = toNixPci integratedCardPci;
        nvidiaBusId = toNixPci discreteCardPci;
    };
}
