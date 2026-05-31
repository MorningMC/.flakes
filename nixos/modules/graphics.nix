{ config, lib, ... }: {
	# Enable hardware acceleration for 32-bit applications
	hardware.graphics.enable32Bit = config.hardware.graphics.enable;

	# Declare video drivers
	services.xserver.videoDrivers = [ "nvidia" "modesetting" "fbdev" ];

	# Configure Nvidia driver on-demand
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

		# Enable PRIME render offload support if hardware acceleration is enabled. PCI addresses is declared in specific host configurations.
		prime.offload = {
			enable = config.hardware.graphics.enable;
			enableOffloadCmd = config.hardware.graphics.enable;
			offloadCmdMainProgram = "prime-run"; # Follows conventional name
		};
	};
}
