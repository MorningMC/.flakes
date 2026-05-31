{ flake, ... }: {
	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# Use modern broker D-Bus implementation
	services.dbus.implementation = "broker";

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
