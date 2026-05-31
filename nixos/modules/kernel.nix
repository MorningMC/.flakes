{ pkgs, ... }: {
	boot = {
		# Specify the Linux kernel used
		kernelPackages = pkgs.linuxPackages_zen;

		# Enable SysRq functions
		kernel.sysctl."kernel.sysrq" = true;

		# Fix ACPI error on boot
		blacklistedKernelModules = [ "acpi_power_meter" ];
	};
}
