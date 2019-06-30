export PS1="$(
    NORMAL="\[\e[0m\]"
    RED="\[\e[1;31m\]"
    GREEN="\[\e[1;32m\]"
    BLUE="\[\e[0;34m\]"
    YELLOW="\[\e[0;33m\]"

    function build-user() {
        if [[ "$(whoami)" = "root" ]]; then
            echo "$RED\u$NORMAL"
        else
            echo "$YELLOW\u$NORMAL"
        fi
    }

    function build-path() {
        echo "$BLUE\W$NORMAL"
    }

    function build-host() {
        echo "$GREEN\h$NORMAL"
    }

    echo "$(build-user)@$(build-host) $(build-path) $ "
)"