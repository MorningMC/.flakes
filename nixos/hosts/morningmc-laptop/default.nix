{ config, pkgs, ... }:

{
	imports = [
		./hardware.nix
		./locale.nix
	];

	# Bootloader configurations
	boot.loader = {
		systemd-boot.enable = true;
		timeout = 0;
		efi.canTouchEfiVariables = true;
	};

	networking = {
		# Define your hostname.
		hostName = "morningmc-laptop";
		
		# Enable networking
		networkmanager.enable = true;
		
		# Enables wireless support via wpa_supplicant. Contradicts with networking.networkmanager.enable
		#wireless.enable = true;
	};

	# Enable bluetooth
	hardware.bluetooth.enable = true;

	# Ignore power key action. This prevents others pressing my power key >:(
	services.logind.settings.Login = {
		HandlePowerKey = "ignore";
		HandlePowerKeyLongPress = "ignore";
	};
}
