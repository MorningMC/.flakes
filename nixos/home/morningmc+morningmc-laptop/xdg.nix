{
    home-manager.users.morningmc = { config, ... }: {
        # Enable management of XDG base directories
        xdg.enable = true;

        # Enable XDG user directories
        xdg.userDirs = {
            enable = true;

            # Export environment variables to session
            setSessionVariables = true;

            # Disable unused directories
            desktop = null;
            publicShare = null;
            templates = null;

            # Add custom directories
            extraConfig.WORKSPACES = config.home.homeDirectory + "/Workspaces";
        };

        # Prefer using XDG directories if they are enabled
        home.preferXdgDirectories = config.xdg.enable;
    };

    # Enable XDG desktop portals
    xdg.portal.enable = true;
}
