{ config, lib, ... }: {
	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# Use modern broker D-Bus implementation
	services.dbus.implementation = "broker";

	programs = {
		# Disable Nano & switch to Neovim. A text editor is required to edit NixOS configurations.
		nano.enable = false;
		neovim = {
			enable = true;

			# Set as default text editor. This configures EDITOR environment variable.
			defaultEditor = true;

			# Symlink vi & vim to nvim binary
			viAlias = true;
			vimAlias = true;
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
