{ inputs, ... }: {
	# Enable Flatpak
	services.flatpak.enable = true;

	# Import nix-flatpak Home Manager module
	home-manager.users.morningmc.imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

	# Manage Flatpak by Home Manager
	home-manager.users.morningmc.services.flatpak = {
		enable = true;

		# Declare packages to install
		packages = [
			"org.gnome.clocks"
			"org.gnome.SoundRecorder"
			"com.usebottles.bottles"
		];

		# Enable periodic update (run weekly by default)
		update.auto.enable = true;

		# Remove unmanaged packages or remotes
		uninstallUnmanaged = true;
	};
}
