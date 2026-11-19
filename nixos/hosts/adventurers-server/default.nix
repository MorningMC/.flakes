{ pkgs, inputs, ... }: {
    boot = {
        # Specify the Linux kernel used
        kernelPackages = pkgs.linuxPackagesFor
            inputs.nix-cachyos-kernel.packages.${pkgs.stdenv.hostPlatform.system}.linux-cachyos-server;

        # Bootloader configurations
        loader = {
            # Enable systemd-boot EFI boot manager
            systemd-boot.enable = true;

            # Limit generation entries in boot partition to prevent boot partition running out of disk space
            systemd-boot.configurationLimit = 32;

            # Boot to NixOS directly without displaying the loader menu
            timeout = 0;

            # Allow the installation process to modify EFI boot variables
            efi.canTouchEfiVariables = true;
        };

        # Mount a tmpfs on `/tmp` during boot
        tmp.useTmpfs = true;
    };

    # Define the hostname of the machine
    networking.hostName = "adventurers-server";

    # Enable OpenSSH daemon to allow remote control
    services.openssh.enable = true;
    services.openssh.settings.PasswordAuthentication = false; # Do not allow password login

    # Specify time zone
    time.timeZone = "Asia/Shanghai";

    # Declare path to agenix host recipient keys
    age.identityPaths = [ "/var/lib/agenix/host_age_pq_key" ];

    # Ignore lid close action to ensure the server runs continously even if the lid is closed
    services.logind.settings.Login.HandleLidSwitch = "ignore";
    services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
}
