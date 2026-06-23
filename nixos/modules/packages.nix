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

	# Enable PipeWire
	services.pipewire = {
		enable = true;

		# Enable PulseAudio support
		pulse.enable = true;

		# Enable ALSA support
		alsa.enable = true;
		alsa.support32Bit = true;

		# Enable JACK support
		jack.enable = true;
	};

	# Enable RealtimeKit system service
	security.rtkit.enable = true;
}
