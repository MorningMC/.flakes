{ config, ... }: {
	# Use NetworkManager to manage network interfaces
	networking.networkmanager.enable = true;

	# Use modern nftables to replace iptables
	networking.nftables.enable = true;

	# Enable network name resolution daemon
	services.resolved.enable = true;

	# Enable FirewallD
	services.firewalld.enable = true;

	# Enable Bluetooth support
	hardware.bluetooth.enable = true;
}
