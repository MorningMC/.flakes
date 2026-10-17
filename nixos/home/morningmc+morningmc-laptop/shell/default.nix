{ pkgs, ... }: {
    # Enable Z Shell
    programs.zsh.enable = true;

    # Set default shell to Zsh
    users.users.morningmc.shell = pkgs.zsh;

    # Manage Z Shell by Home Manager
    home-manager.users.morningmc = { config, lib, ... }: {
        programs.zsh = {
            enable = true;

            # Specify configuration locations based on XDG directories preference
            dotDir = if config.home.preferXdgDirectories
                then config.xdg.configHome + "/zsh" # Default after Home Manager state version 26.05
                else config.home.homeDirectory; # Default before Home Manager state version 26.05

            # Automatically enter into a directory if typed directly into shell
            autocd = true;

            # Enable autosuggestions
            autosuggestion.enable = true;

            # Enable syntax highlighting
            syntaxHighlighting.enable = true;

            # Enable history substring search
            historySubstringSearch = {
                enable = true;

                # Map up and down keys
                searchUpKey = [ "$terminfo[kcuu1]" ];
                searchDownKey = [ "$terminfo[kcud1]" ];
            };

            # Declare aliases
            shellAliases = {
                sudo = "sudo -E";
                ff = "fastfetch";
                hypr = "start-hyprland";
            };

            # Declare scripts to append to .zshrc
            initContent = lib.mkAfter ''
                # Launch Fastfetch in an interactive shell and not already marked
                if [[ $(tty) != /dev/tty* ]] && [[ -z "$__SHELL_SESSION" ]]; then
                    export __SHELL_SESSION=1
                    clear
                    fastfetch
                fi
            '';
        };
    };

    # Get Zsh completion for system packages
    environment.pathsToLink = [ "/share/zsh" ];
}
