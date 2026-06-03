{ config, lib, modulesPath, ... }: {
	imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

	boot = {
		initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
		initrd.kernelModules = [ ];
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];

		# Specify the swap device used for hibernation
		resumeDevice = "/dev/disk/by-uuid/f6655e33-f593-4c1f-b173-b4acce0fe07a";
	};

	# Enable hibernation
	powerManagement.enable = true;

	# Declare mount points
	fileSystems = {
		"/" = {
			device = "/dev/disk/by-uuid/2274497c-9641-4913-b7ab-c1b443bae1f2";
			fsType = "ext4";
		};

		"/boot" = {
			device = "/dev/disk/by-uuid/7B47-D19E";
			fsType = "vfat";
			options = [ "fmask=0077" "dmask=0077" ];
		};
	};

	# Declare swap devices mounted
	swapDevices = [
		{ device = "/dev/disk/by-uuid/f6655e33-f593-4c1f-b173-b4acce0fe07a"; }
	];

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
