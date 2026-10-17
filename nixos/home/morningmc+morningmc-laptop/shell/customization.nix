{ lib, pkgs, inputs, ... }: {
    home-manager.users.morningmc.programs.zsh = {
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

        # Configure Headline theme
        initContent = lib.mkAfter ''
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

            # Restore EOL mark removed by Headline theme
            PROMPT_EOL_MARK='%K{red}%F{black}%#%k%f'
        '';
    };
}
