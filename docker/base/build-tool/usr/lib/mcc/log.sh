function log()              { local LEVEL="$1"; shift; echo -e "[mcc] [$MCC_COMMAND] [$LEVEL] " "$@"; }
function log_info()         { log "INFO" $@; }
function log_ok()           { log "OK" $@; }
function log_error()        { log "ERROR" $@ >&2; }
function log_warning()      { log "WARN" $@; }

function log_task() {
    local MSG="$1"; shift

    eval "$@" && log_ok " * $MSG"

    local RET=$?

    if [[ ${RET} -ne 0 ]]; then
        log_error "Failed ($RET): "$@": $MSG"
        return ${RET}
    fi
}

function log_file_contents() {
    local FILEPATH="$1"

    echo -e "\n  --- BEGIN FILE $FILEPATH ---"
    cat "$FILEPATH" | sed -e 's/^/  /'
    echo -e "  --- END FILE $FILEPATH ---\n"
}
