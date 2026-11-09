{ config, lib, pkgs, inputs, ... }: {
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

        # Use system packages. Don't let Home Manager manage them.
        package = null;
        portalPackage = null;

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
    };

    # Install external Lua plugins
    home-manager.users.morningmc.xdg.configFile."hypr/plugins/split-monitor-workspaces".source =
        inputs.split-monitor-workspaces;
}
