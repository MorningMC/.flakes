{ config, ... }: {
	# Enable Flatpak
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
	};
}
