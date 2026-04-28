{ config, pkgs, ... }: {
	# Use stable Linux kernel.
	boot.kernelPackages = pkgs.linuxPackages_zen;

	# Enable SysRq functions
	boot.kernel.sysctl."kernel.sysrq" = 1;
}
