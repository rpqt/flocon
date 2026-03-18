if status is-interactive
    # Commands to run in interactive sessions can go here
    source $XDG_CONFIG_HOME/sh/aliases.sh
    source $XDG_CONFIG_HOME/sh/path.sh

    # Per-host config
    if test -r $XDG_CONFIG_HOME/sh/$HOSTNAME.sh
        source $XDG_CONFIG_HOME/sh/$HOSTNAME.sh
    end

    if type -q atuin
        atuin init fish | source
    end

    if type -q zoxide
        zoxide init fish | source
        alias cd=z
    end

    if type -q direnv
        direnv hook fish | source
    end
end
