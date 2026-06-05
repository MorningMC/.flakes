{ config, lib, modulesPath, ... }: {
	imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

	boot = {
		initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
		initrd.kernelModules = [ ];
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];

		# Specify the swap device used for hibernation
		resumeDevice = "/dev/disk/by-uuid/04e4dd4b-f966-4a2f-a779-ff4bb65309c7";
	};

	# Enable hibernation
	powerManagement.enable = true;

	# Declare mount points
	fileSystems = {
		"/" = {
			device = "/dev/disk/by-uuid/151296a2-5a83-47ea-b811-cad97d6455ad";
			fsType = "ext4";
		};

		"/boot" = {
			device = "/dev/disk/by-uuid/A39C-F21F";
			fsType = "vfat";
			options = [ "fmask=0077" "dmask=0077" ];
		};
	};

	# Declare swap devices mounted
	swapDevices = [
		{ device = "/dev/disk/by-uuid/04e4dd4b-f966-4a2f-a779-ff4bb65309c7"; }
	];

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
