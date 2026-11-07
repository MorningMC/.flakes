{ options, lib, ... }: let
    # Import helper functions
    toNixPci = import ../../lib/to-nix-pci.nix { inherit lib; };

    # Declare PCI addresses for graphics cards
    integratedCardPci = "0000:00:02.0";
    discreteCardPci = "0000:02:00.0";
in
{
    # Declare video drivers
    services.xserver.videoDrivers = [ "nvidia" ];

    # Enable PRIME render offload support
    hardware.nvidia.prime = {
        offload.enable = true;

        # Specify Intel & NVIDIA PCI address
        intelBusId = toNixPci integratedCardPci;
        nvidiaBusId = toNixPci discreteCardPci;
    };
}
