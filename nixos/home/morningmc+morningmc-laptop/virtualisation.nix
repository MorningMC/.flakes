{ config, ... }: {
    # Declare encrypted secrets used
    age.secrets.morningmc_container-windows.file = ./_secrets/container-windows.env.age;

    # Declare Windows VM container
    virtualisation.oci-containers.containers.windows = {
        # Declare used container image
        image = "ghcr.io/dockur/windows";

        # Declare the environment variables
        environment = {
            VERSION = "11"; # Use Windows 11
            RAM_SIZE = "12G"; # Allocate 12 GiB memory maximum
            CPU_CORES = "8"; # Allocate 8 CPU cores maximum
            CPU_FLAGS = "-hypervisor"; # Unset CPU hypervisor flag
        };

        # Include secrets
        environmentFiles = [ config.age.secrets.morningmc_container-windows.path ];

        # Declare devices mapped to the container
        devices = [ "/dev/kvm" "/dev/net/tun" ];

        # Allow the container to access network devices & interfaces
        capabilities.NET_ADMIN = true;

        # Declare volumes mapped to the container
        volumes = [
            "${config.users.users.morningmc.home}/.container/windows/storage:/storage"
            "${config.users.users.morningmc.home}:/shared"
        ];

        # Declare ports mapped to the container
        ports = [
            "8006:8006"
            "3389:3389/tcp"
            "3389:3389/udp"
        ];

        # Specify stop grace period
        extraOptions = [ "--stop-timeout=60" ]; # 1 min

        # Prevent starting on machine boot
        autoStart = false;
    };

    # Enable dynamic CDI configuration for NVIDIA devices
    hardware.nvidia-container-toolkit.enable = config.hardware.nvidia.enabled;
}
