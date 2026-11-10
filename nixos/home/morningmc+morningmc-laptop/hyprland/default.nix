{ lib, pkgs, inputs, ... }: {
    # Enable Hyprland
    programs.hyprland.enable = true;

    # Manage Hyprland by Home Manager
    home-manager.users.morningmc = { config, ... }: {
        wayland.windowManager.hyprland = {
            enable = true;

            # Use system packages. Don't let Home Manager manage them.
            package = null;
            portalPackage = null;

            # Specify configuration type
            configType = "lua"; # Default after Home Manager state version 26.05

            # Include Lua configurations
            extraLuaFiles = let
                # Import helper functions
                replacePkgs = import ../../../lib/replace-pkgs.nix { inherit lib pkgs; };

                # Declare shell scripts used
                googleLensSearch = pkgs.writeShellApplication {
                    name = "google-lens-search";
                    text = builtins.readFile ./google-lens-search.sh;
                    runtimeInputs = with pkgs; [
                        curl
                        jq
                        xdg-utils

                        config.programs.noctalia.package # Requires Noctalia IPC
                    ];
                    bashOptions = [ "errexit" "nounset" ]; # The script fails when `errexit` & `pipefail` are both set
                };
            in
            {
                general = ./general.lua;
                animations = ./animations.lua;
                autostart = ./autostart.lua;
                rules = ./rules.lua;
                keybinds = replacePkgs ./keybinds.lua {
                    inherit googleLensSearch;
                    inherit (pkgs) hyprpicker hyprshutdown;
                    noctalia = config.programs.noctalia.package;
                };
                monitors = ./monitors.lua;
                gestures = ./gestures.lua;
            };

            # Handle XDG autostart desktop entries
            systemd.enableXdgAutostart = true;
        };

        # Install external Lua plugins
        xdg.configFile."hypr/plugins/split-monitor-workspaces".source = inputs.split-monitor-workspaces;
    };
}
