{ config, pkgs, flake, inputs, ... }: {
	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search <package>
	environment.systemPackages = with pkgs; [ ];

	services = {
		# Use modern broker D-Bus implementation
		dbus.implementation = "broker";

		# Enable Ly display manager
		displayManager.ly = {
			enable = true;

			settings = {
				# Specify background animation
				animation = "dur_file";
				dur_file_path = "${inputs.ly-blackhole}";
				full_color = true; # Enable 256 color mode

				# Enable clock widget
				bigclock = true;
			};
		};
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
			inherit flake; # Use current flake

			# Setup garbage cleaner (this makes nix.gc obsolete)
			clean = {
				enable = true;
				dates = "daily";
				extraArgs = "--keep 3 --keep-since 7d";
			};
		};

		# Enable AppImage support
		appimage.enable = true;
		appimage.binfmt = true;
	};

	# Allow passwordless wheel group
	security.sudo.wheelNeedsPassword = false;
}
