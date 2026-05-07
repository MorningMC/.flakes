{ config, pkgs, ... }: {
	boot = {
		# Specify the Linux kernel used
		kernelPackages = pkgs.linuxPackages_zen;

		# Enable SysRq functions
		kernel.sysctl."kernel.sysrq" = 1;

		# Fix ACPI Error on boot
		blacklistedKernelModules = [ "acpi_power_meter" ];
	};
}
