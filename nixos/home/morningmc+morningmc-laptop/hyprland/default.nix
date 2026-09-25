{ config, lib, pkgs, ... }: {
    users.users.morningmc.packages = with pkgs; [
        # Hypr ecosystem
        hyprpicker # Color picker
        hyprshutdown # Graceful shutdown
    ];

    # Enable Hyprland
    programs.hyprland.enable = true;

    # Manage Hyprland by Home Manager
    home-manager.users.morningmc.wayland.windowManager.hyprland = {
        enable = true;
        package = null; # Using system Hyprland package

        # Specify configuration type
        configType = "lua"; # Default after Home Manager state version 26.05

        # Include Lua configurations
        extraLuaFiles = {
            general = ./general.lua;
            animations = ./animations.lua;
            autostart = ./autostart.lua;
            rules = ./rules.lua;
            keybinds = ./keybinds.lua;
            monitors = ./monitors.lua;
            gestures = ./gestures.lua;
        };

        # Handle XDG autostart desktop entries
        systemd.enableXdgAutostart = true;

        # Do not manage XDG desktop portals
        portalPackage = null;
    };

    # Configure environment variables for Hyprland if NVIDIA support is enabled
    # See https://wiki.hypr.land/nvidia for more details
    home-manager.users.morningmc.home.sessionVariables = lib.mkIf config.hardware.nvidia.enabled {
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";

        # Enable VA-API hardware video acceleration
        NVD_BACKEND = "direct";
    };
}
