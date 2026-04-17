{ config, pkgs, ... }:

{
	imports = [
		./hardware.nix
		./locale.nix
	];

	# Bootloader configurations
	boot.loader = {
		systemd-boot.enable = true;
		systemd-boot.configurationLimit = 5; # Limit generation entries in boot partition
		timeout = 0;
		efi.canTouchEfiVariables = true;
	};

	networking = {
		# Define your hostname.
		hostName = "morningmc-laptop";
		
		# Enable networking
		networkmanager.enable = true;
	};

	# Enable bluetooth
	hardware.bluetooth.enable = true;

	# Ignore power key action. This prevents others pressing my power key >:(
	services.logind.settings.Login = {
		HandlePowerKey = "ignore";
		HandlePowerKeyLongPress = "ignore";
	};
}
