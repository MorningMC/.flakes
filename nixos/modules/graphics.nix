{ config, pkgs, ... }: {
	# Enable hardware acceleration for graphics and videos
	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	# Make graphics libraries discoverable by applications
	environment.sessionVariables.LD_LIBRARY_PATH = "/run/opengl-driver/lib";

	# Enable Nvidia drivers
	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.nvidia = {
		open = true; # Use open-source kernel module
		modesetting.enable = true;
		powerManagement.enable = true;
	};
}
