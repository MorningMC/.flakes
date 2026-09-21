{ config, ... }: {
    # Declare encrypted secrets used
    age.secrets.morningmc_password.file = ./_secrets/password.age;

    # Define a user account
    users.users.morningmc = {
        # Declare an account for normal users
        isNormalUser = true;

        # The description of the user
        description = "Adventurers' Update 2 Server Administrator";

        # Declare the user’s additional groups besides 'users'
        extraGroups = [ "wheel" "networkmanager" ];

        # Declare the password of the user
        hashedPasswordFile = config.age.secrets.morningmc_password.path;
    };

    # Let Home Manager install and manage itself
    home-manager.users.morningmc.programs.home-manager.enable = true;

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home-manager.users.morningmc.home.stateVersion = "25.11"; # Did you read the comment?
}
