{ config, pkgs, ... }: {
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
