{ config, pkgs, ... }: {
	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	services.xserver.videoDrivers = [ "nvidia" ];

	hardware.nvidia = {
		open = true; # Use open-source kernel module
		modesetting.enable = true;
		powerManagement.enable = true;
	};
}
