{ config, lib, pkgs, ... }: let
    # Create wrapper to pass environment variables of graphics driver path when hardware acceleration is enabled
    btop-wrapped = pkgs.symlinkJoin {
        name = ".btop-wrapped";
        paths = [ pkgs.btop ];
        buildInputs = [ pkgs.makeBinaryWrapper ];
        postBuild = "wrapProgram $out/bin/btop --set LD_LIBRARY_PATH /run/opengl-driver/lib";

        # Pass through the metadata of Btop
        meta = pkgs.btop.meta;
    };
in
{
    # Create wrapper for Btop to monitor graphics cards
    security.wrappers.btop = {
        # Specify the target executable to be wrapped
        source = lib.getExe (
            # Create an additional wrapper if hardware acceleration is enabled
            if config.hardware.graphics.enable
            then btop-wrapped
            else pkgs.btop
        );

        # Specify the owner & the group of the wrapper program
        owner = "root";
        group = "root";

        # Allows Btop to monitor system performance
        capabilities = "cap_perfmon=+ep";
    };
}
