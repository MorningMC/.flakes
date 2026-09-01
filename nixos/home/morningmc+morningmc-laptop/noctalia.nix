{
    # Enable Noctalia shell
    home-manager.users.morningmc.programs.noctalia.enable = true;

    # Declare Noctalia configurations
    home-manager.users.morningmc.programs.noctalia.settings = {
        # Declare default bar settings
        bar.default = {
            # Specify font
            font_family = "JetBrainsMono NF";

            # Specify background opacity
            background_opacity = 0.9;

            # Keep margins identical to Hyprland window margins
            margin_edge = 5;
            margin_ends = 5;
        };

        # Specify theme settings
        theme.source = "wallpaper";
        theme.wallpaper_scheme = "m3-rainbow";
    };
}
