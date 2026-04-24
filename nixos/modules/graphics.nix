{ config, pkgs, ... }: {
	# Enable hardware acceleration for graphics and videos
	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	# Make graphics libraries discoverable by applications
	environment.sessionVariables = let
		driversPath = [ "/run/opengl-driver/lib" ];
	in
	{
		LIBGL_DRIVERS_PATH = driversPath;
		LD_LIBRARY_PATH = driversPath;
	};

	# Enable Nvidia drivers
	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.nvidia = {
		open = true; # Use open-source kernel module
		modesetting.enable = true;
		powerManagement.enable = true;

		# Enable PRIME render offload support. PCI addresses is declared in specific host configurations.
		prime.offload = {
			enable = true;
			enableOffloadCmd = config.hardware.nvidia.prime.offload.enable;
			offloadCmdMainProgram = "prime-run"; # Follows conventional name
		};
	};
}
