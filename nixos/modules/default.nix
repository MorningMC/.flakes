{ config, pkgs, flake, ... }:

{
	imports = [
		./nvidia.nix
		./pipewire.nix
		./locale.nix
	];
	
	# Use linux-zen kernel.
	boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search <package>
	environment.systemPackages = with pkgs; [
		ripgrep # Used by Neovim for searching
	];

	services = {
		# Enable the OpenSSH daemon (NOT client)
		#openssh.enable = true;

		# Enable systemd-resolved
		resolved.enable = true;
	};

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
				enable = false;
				dates = "weekly";
				extraArgs = "--keep 20 --keep-since 42d";
			};
			inherit flake; # Use current flake
		};

		# Enable AppImage support
		appimage = {
			enable = true;
			binfmt = true;
		};
	};
  
	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;
}
