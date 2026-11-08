{ config, lib, inputs, ... }: {
    imports = [
        # Import impermanence module
        inputs.impermanence.nixosModules.default
    ];

    # Declare host platform
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    # Declare kernel modules included in the initial ramdisk
    boot.initrd.availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
    ];

    # Declare kernel modules to be loaded in the second stage of the boot process
    boot.kernelModules = [ "kvm-intel" ];

    # Enable hibernation
    powerManagement.enable = true;

    # Declare mount points
    fileSystems = {
        # Impermanent root setup
        "/".fsType = "tmpfs";
        "/".options = [ "mode=755" ];

        # Home directories
        "/home" = {
            device = "/dev/disk/by-uuid/217ec580-ef59-409c-814a-852908c00852";
            fsType = "btrfs";
            options = [ "subvol=@home" "compress-force=zstd" ];
        };

        # Nix store & profiles
        "/nix" = {
            device = "/dev/disk/by-uuid/217ec580-ef59-409c-814a-852908c00852";
            fsType = "btrfs";
            options = [ "subvol=@nix" "compress-force=zstd" "noatime" ];
        };

        # Persistent files across boots
        "/var" = {
            device = "/dev/disk/by-uuid/217ec580-ef59-409c-814a-852908c00852";
            fsType = "btrfs";
            options = [ "subvol=@var" "compress-force=zstd" ];
        };

        # UEFI partition
        "/boot" = {
            device = "/dev/disk/by-uuid/9436-0E9F";
            fsType = "vfat";
            options = [ "fmask=0077" "dmask=0077" ];
        };
    };

    # Declare swap devices mounted
    swapDevices = [
        { device = "/dev/disk/by-uuid/6eb5dd68-dfa0-400c-8e3e-1470849d272b"; }
    ];

    # Declare presistent files & directories outside mount points
    environment.persistence."/var/persistent".directories = [
        "/etc/NetworkManager/system-connections"
        "/etc/wpa_supplicant"
    ];
    environment.persistence."/var/persistent".files = [
        "/etc/machine-id"
    ];

    # Enable non-free firmware on devices not recognized by `nixos-generate-config`
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
