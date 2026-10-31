{ config, lib, ... }: let
    # Define flake paths for each machine. The key of the attribute set should be the host name & the value should be a string representing
    # the path of this flake on that machine.
    flakePaths = {
        morningmc-laptop = config.users.users.morningmc.home + "/.flakes/nixos";
    };
in
{
    # Enable NH command helper
    programs.nh = {
        enable = true;

        # Specify flake path if it is declared above
        flake = lib.mkIf (flakePaths ? config.networking.hostName) flakePaths.${config.networking.hostName};

        # Setup garbage cleaner (this makes nix.gc obsolete)
        clean.enable = true;
        clean.extraArgs = "--keep 3 --keep-since 15d"; # Keep the latest 3 generations & generations younger than half a month
    };

    # Disable system garbage collector if NH clean is enabled
    nix.gc.automatic = ! config.programs.nh.clean.enable;
}
