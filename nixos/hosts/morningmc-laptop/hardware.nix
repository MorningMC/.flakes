{ config, lib, pkgs, modulesPath, system, ... }: {
	imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

	boot = {
		initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" ];
		initrd.kernelModules = [ ];
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
		
		# Specify the swap device used for hibernation
		resumeDevice = "/dev/disk/by-uuid/6eb5dd68-dfa0-400c-8e3e-1470849d272b";
	};

	# Enable hibernation
	powerManagement.enable = true;

	# Declare mount points
	fileSystems = {
		"/" = {
			device = "/dev/disk/by-uuid/217ec580-ef59-409c-814a-852908c00852";
			fsType = "btrfs";
			options = [ "subvol=@" ];
		};

		"/home" = {
			device = "/dev/disk/by-uuid/217ec580-ef59-409c-814a-852908c00852";
			fsType = "btrfs";
			options = [ "subvol=@home" ];
		};

		"/nix" = {
			device = "/dev/disk/by-uuid/217ec580-ef59-409c-814a-852908c00852";
			fsType = "btrfs";
			options = [ "subvol=@nix" "compress=zstd" "noatime" ];
		};

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

	nixpkgs.hostPlatform = lib.mkDefault system;
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

	# Specify Intel & Nvidia PCI address as Nvidia PRIME requires these
	hardware.nvidia.prime = {
		intelBusId = "PCI:0@0:2:0";
		nvidiaBusId = "PCI:2@0:0:0";
	};
}
