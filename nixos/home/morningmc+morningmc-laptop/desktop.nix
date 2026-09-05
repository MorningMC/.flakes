{ config, lib, pkgs, inputs, ... }: {
    users.users.morningmc.packages = with pkgs; [
        wl-clipboard # Wayland clipboard service
        bibata-cursors # Cursor theme
    ];

    # Enable Plasma 6 desktop environment
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        kate
        gwenview
        okular
        elisa
        qrca
        discover
        konsole
        spectacle
        plasma-systemmonitor
        kwallet
        kwalletmanager
    ];

    # Setup environment variables
    home-manager.users.morningmc.home.sessionVariables = {
        NIXOS_OZONE_WL = 1;
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_QPA_PLATFORMTHEME = "kde";
        XDG_MENU_PREFIX = "plasma-";
        GDK_BACKEND = "wayland";
    };
}
