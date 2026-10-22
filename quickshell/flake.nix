{
    description = "Quickshell bundled Qt deps for home-manager usage";

    # Declare external dependencies
    inputs = {
        # The Nixpkgs channel used
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        # Quickshell in Nixpkgs is outdated. Use flake from git repository.
        quickshell = {
            url = "git+https://git.outfoxxed.me/quickshell/quickshell";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Import end-4's dots-hyprland as build script
        dots-hyprland = {
            url = "github:end-4/dots-hyprland";
            flake = false; # Only quickshell.nix is used. We don't need a entire flake.
        };
    };

    # Declare the outputs
    outputs = { nixpkgs, quickshell, dots-hyprland, ... }: let
        system = "x86_64-linux"; # Only generate for x86_64-linux as this is hardcoded to dots-hyprland script
        pkgs = nixpkgs.legacyPackages.${system};
        script = import "${dots-hyprland}/sdata/dist-nix/home-manager/quickshell.nix";
    in
    {
        # Use package defined in dots-hyprland & pass Quickshell package as a dependency
        packages.${system}.default = pkgs.callPackage script { inherit quickshell; };
    };
}
