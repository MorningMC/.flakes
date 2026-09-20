{
    # Enable PipeWire sound server
    services.pipewire.enable = true;

    # Configure echo cancellation
    services.pipewire.extraConfig.pipewire."60-echo-cancel"."context.modules" = [
        {
            name = "libpipewire-module-echo-cancel";
            args = {
                # Make a stream that captures from the monitor ports of the default sink
                "monitor.mode" = true;

                # Declare the capture device (microphone)
                "capture.props"."node.name" = "alsa_input.pci-0000_80_1f.3.analog-stereo";

                # Declare the source device (echo-cancelled output stream)
                "source.props"."node.name" = "echo-cancel-source";
                "source.props"."node.description" = "Echo Cancellation Output Stream";

                # Declare the playback device (speaker)
                "playback.props"."node.name" = "alsa_output.pci-0000_80_1f.3.analog-stereo";
            };
        }
    ];
}
