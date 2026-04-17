{ config, pkgs, flake, ... }:

{
	# Use linux-zen kernel.
	boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search <package>
	environment.systemPackages = with pkgs; [
	];

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
			clean = {
				enable = true;
				dates = "weekly";
				extraArgs = "--keep 3 --keep-since 7d";
			};
			inherit flake; # Use current flake
		};

		# Enable AppImage support
		appimage = {
			enable = true;
			binfmt = true;
		};
	};

	# Allow passwordless wheel group
	security.sudo.wheelNeedsPassword = false;
}
