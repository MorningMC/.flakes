{ pkgs, inputs, ... }: {
    # Install agenix CLI tool
    users.users.morningmc.packages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];

    # Automatically start GNOME Keyring
    home-manager.users.morningmc.services.gnome-keyring.enable = true;

    # Enable Policykit agent
    home-manager.users.morningmc.services.polkit-gnome.enable = true;

    # Enable Policykit daemon
    security.polkit.enable = true;

    # Enable GNOME Keyring
    services.gnome.gnome-keyring.enable = true;
}
