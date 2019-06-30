. "${MCC_PREFIX}/lib/mcc/cfg.sh"
. "${MCC_PREFIX}/lib/mcc/log.sh"
. "${MCC_PREFIX}/lib/mcc/util.sh"
. "${MCC_PREFIX}/lib/mcc/component.sh"

function mcc_cli_cleanup() {
    [[ -z "$MCC_TMPDIR" ]] || rm -rf "$MCC_TMPDIR"
}

function mcc_cli_list_command_binaries() {
    mcc_list_files "${MCC_PREFIX}/bin" "${MCC}-*"
}

function mcc_cli_extract_command_name() {
    echo ${1#"$MCC-"}
}

function mcc_cli_list_commands() {
    mcc_cli_list_command_binaries | while read CMD_NAME ; do
        mcc_cli_extract_command_name "$CMD_NAME"
    done
}

function mcc_cli_get_command_binary() {
    echo "${MCC_PREFIX}/bin/${MCC}-$1"
}

function mcc_cli_has_command() {
    [[ -f "$(mcc_cli_get_command_binary "$1")" ]]
}

function mcc_cli_show_help() {
    echo -e "Usage: ${MCC_CALL} $(mcc_call_usage)"
}

[[ ! -z "$MCC_COMMAND" ]]   || MCC_COMMAND="$1"
[[ ! -z "$MCC_CALL" ]]      || MCC_CALL="$0"
[[ -d "$MCC_TMPDIR" ]]      || mkdir -p "$MCC_TMPDIR"

if [[ "$1" == *"--help"* ]] || [[ "$1" == *"-h"* ]] ; then
    mcc_cli_show_help
    exit 0
fi