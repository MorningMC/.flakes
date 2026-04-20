{ config, ... }: {
	# Enable Flatpak
	services.flatpak = {
		enable = true;

		# Declare packages to install
		packages = [
			"com.github.tchx84.Flatseal"
			"com.usebottles.bottles"
			"org.gnome.Calculator"
			"org.gnome.Snapshot"
			"org.gnome.SoundRecorder"
		];

		# Enable periodic update (run weekly by default)
		update.auto.enable = true;
	};
}
