{
    # Bootloader configurations
    boot.loader = {
        # Enable systemd-boot EFI boot manager
        systemd-boot.enable = true;

        # Limit generation entries in boot partition to prevent boot partition running out of disk space
        systemd-boot.configurationLimit = 32;

        # Boot to NixOS directly without displaying the loader menu
        timeout = 0;

        # Allow the installation process to modify EFI boot variables
        efi.canTouchEfiVariables = true;
    };

    # Delete all files in /tmp during boot
    boot.tmp.cleanOnBoot = true;

    # Define the hostname of the machine
    networking.hostName = "morningmc-laptop";

    # Specify default location provider
    location.provider = "geoclue2";

    services = {
        # Automatically adjust timezone in terms of geographic location
        automatic-timezoned.enable = true;

        # Ignore power key action. This prevents others pressing my power key >:(
        logind.settings.Login.HandlePowerKey = "ignore";
        logind.settings.Login.HandlePowerKeyLongPress = "ignore";
    };

    # Enable oomd on user slices to prevent memory outage
    systemd.oomd.enableUserSlices = true;
}
