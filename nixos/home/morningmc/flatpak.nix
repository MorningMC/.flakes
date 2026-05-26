{ config, inputs, ... }: {
	# Enable Flatpak
	services.flatpak.enable = true;

	home-manager.users.morningmc = {
		# Import nix-flatpak Home Manager module
		imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

		# Manage Flatpak by Home Manager
		services.flatpak = {
			enable = true;

			# Declare packages to install
			packages = [
				"org.gnome.clocks"
				"org.gnome.Calculator"
				"org.gnome.Snapshot"
				"org.gnome.SoundRecorder"
				"com.github.tchx84.Flatseal"
				"com.usebottles.bottles"
			];

			# Enable periodic update (run weekly by default)
			update.auto.enable = true;

			# Remove unmanaged packages or remotes
			uninstallUnmanaged = true;
		};
	};
}
