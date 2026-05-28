{ config, pkgs, ... }: {
	# Enable hardware acceleration for 32-bit applications
	hardware.graphics.enable32Bit = config.hardware.graphics.enable;

	# Enable Nvidia drivers
	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.nvidia = {
		# Use open-source kernel module
		open = true;

		# Enable kernel modesetting
		modesetting.enable = true;

		# Enable power management through systemd
		powerManagement = {
			enable = true;
			finegrained = true; # Enable for PRIME offload
		};

		# Enable PRIME render offload support. PCI addresses is declared in specific host configurations.
		prime.offload = {
			enable = true;
			enableOffloadCmd = config.hardware.nvidia.prime.offload.enable;
			offloadCmdMainProgram = "prime-run"; # Follows conventional name
		};
	};
}
