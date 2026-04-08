source $XDG_CONFIG_HOME/sh/aliases.sh
source $XDG_CONFIG_HOME/sh/path.sh
if [ -r $XDG_CONFIG_HOME/sh/$HOSTNAME.sh ]; then
	source $XDG_CONFIG_HOME/sh/$HOSTNAME.sh
fi
source $XDG_CONFIG_HOME/bash/hooks.sh
source $XDG_CONFIG_HOME/bash/aliases.sh
