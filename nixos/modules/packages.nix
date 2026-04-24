{ config, pkgs, flake, ... }: {
	# Use stable Linux kernel.
	boot.kernelPackages = pkgs.linuxPackages;

	# Enable SysRq functions
	boot.kernel.sysctl."kernel.sysrq" = 1;

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search <package>
	environment.systemPackages = with pkgs; [ ];

	# Enable the OpenSSH daemon (NOT client)
	#services.openssh.enable = true;

	# Enable systemd-resolved
	services.resolved.enable = true;

	programs = {
		# Disable Nano & switch to Neovim. A text editor is required to edit NixOS configurations.
		nano.enable = false;
		neovim = {
			enable = true;
			defaultEditor = true; # Set as default text editor
			viAlias = true;
			vimAlias = true;
		};

		# Enable NH command helper
		nh = {
			enable = true;
			inherit flake; # Use current flake

			# Setup garbage cleaner (this makes nix.gc obsolete)
			clean = {
				enable = true;
				dates = "daily";
				extraArgs = "--keep 3 --keep-since 7d";
			};
		};

		# Enable AppImage support
		appimage = {
			enable = true;
			binfmt = true;
		};
	};

	# Expose shared libraries to environment variables
	environment.sessionVariables.LD_LIBRARY_PATH = [ "/run/current-system/sw/lib" ];

	# Allow passwordless wheel group
	security.sudo.wheelNeedsPassword = false;
}
