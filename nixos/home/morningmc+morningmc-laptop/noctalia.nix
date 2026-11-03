{
    home-manager.users.morningmc = { config, ... }: {
        # Enable Noctalia shell
        programs.noctalia.enable = true;

        # Declare Noctalia configurations
        programs.noctalia.settings = {
            shell = {
                # Declare global default font
                font_family = "JetBrainsMono NF";

                # Launch applications in separate Systemd services if Systemd integration is enabled, otherwise any
                # apps launched by Noctalia will be terminated when the service restarts
                launch_apps_as_systemd_services = config.programs.noctalia.systemd.enable;

                panel = {
                    # Make panels detached from the bar
                    control_center_placement = "floating";
                    session_placement = "floating";

                    # Display Control Center panel next to the clicked widget
                    open_near_click_control_center = true;
                };

                # Only copy screenshot to clipboard
                screenshot.save_to_file = false;
            };

            # Specify Control Center's sidebar style
            control_center.sidebar = "full";

            # Specify the width Control Center panel
            control_center.width = 900;

            # Declare default bar settings
            bar.default = {
                # Specify background opacity
                background_opacity = 0.9;

                # Keep margins identical to Hyprland window margins
                margin_edge = 5;
                margin_ends = 5;

                # Padding inside the bar content area
                padding = 25;
            };

            # Specify wallpaper directory
            wallpaper.directory = config.xdg.userDirs.pictures + "/desktop";

            # Specify theme settings
            theme.source = "wallpaper";
            theme.wallpaper_scheme = "m3-rainbow";

            # Allow volume above 100%
            audio.enable_overdrive = true;
        };
    };
}
