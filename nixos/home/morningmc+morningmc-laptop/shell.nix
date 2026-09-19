{ pkgs, inputs, ... }: {
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

            # Configure Oh My Zsh
            oh-my-zsh = {
                enable = true;

                # Create a custom Oh My Zsh override to install Headline theme
                custom = toString (pkgs.runCommand "headline-oh-my-zsh-custom" { } ''
                    install -Dt $out/themes ${inputs.headline}/headline.zsh-theme
                '');

                # Specify shell theme
                theme = "headline";

                # Specify plugins to install
                plugins = [ "git" "sudo" "kitty" ];
            };

            # Manage plugins with Zplug
            zplug.enable = true;
            zplug.plugins = [
                { name = "Aloxaf/fzf-tab"; }
            ];

            # Declare scripts to append to .zshrc
            initContent = lib.mkAfter ''
                # Launch Fastfetch in an interactive shell and not already marked
                if [[ $(tty) != /dev/tty* ]] && [[ -z "$__SHELL_SESSION" ]]; then
                    export __SHELL_SESSION=1
                    clear
                    fastfetch
                fi

                # Configure Headline theme
                HL_LAYOUT_TEMPLATE[_PRE]="--''${IS_SSH+ssh-}" # shows "ssh " if this is an ssh session
                HL_LAYOUT_TEMPLATE[_POST]='--'
                HL_LAYOUT_TEMPLATE[_SPACER]='--'

                HL_CONTENT_TEMPLATE=(
                    USER   "%{$bold$red%} ..."
                    HOST   "%{$bold$yellow%}󰇅 ..."
                    VENV   "%{$bold$green%} ..."
                    PATH   "%{$bold$blue%} ..."
                    BRANCH "%{$bold$cyan%} ..."
                    STATUS "%{$bold$magenta%}..."
                )

                HL_SEP_MODE='off' # Do not show separator
                HL_SPACE_CHAR='-'
                HL_GIT_COUNT_MODE='on'
                HL_GIT_SEP_SYMBOL='|'
                HL_GIT_STATUS_SYMBOLS[CONFLICTS]="%{$red%}✘"
                HL_GIT_STATUS_SYMBOLS[CLEAN]="%{$green%}✔"
                HL_CLOCK_MODE='on'
                HL_ERR_MODE='detail'
            '';
        };
    };

    # Get Zsh completion for system packages
    environment.pathsToLink = [ "/share/zsh" ];
}
