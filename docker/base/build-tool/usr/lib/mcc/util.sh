function mcc_list_files() {
    (cd "$1"; ls -1dp $2 | grep -v '/')
}

function mcc_fs_list_find_args() {
    echo -n " -xdev"

    for EXC in "${MCC_FS_EXCLUDES[@]}" ; do
        echo -n " -path ${EXC} -prune -o"
    done

    echo -n " -printf %P\n"
}

function mcc_fs_list() {
    find / `mcc_fs_list_find_args` $@
}

function mcc_env_list() {
    env | grep -v -E "$MCC_ENV_EXCLUDE_REGEX"
}

function mcc_env_list_diff() {
    diff "$1" "$2" \
        ${MCC_DIFF_OPTS[@]}
}

function mcc_fs_list_diff() {
    diff  "$1" "$2" \
        ${MCC_DIFF_OPTS[@]} \
        --speed-large-files
}

function mcc_diff_filter_new() {
    grep -e '^+[^+]' | sed 's/^+//'
}

function mcc_diff_filter_unchanged() {
    grep -e '^=[^=]' | sed 's/^=//'
}

function mcc_diff_filter_removed() {
    grep -e '^-[^-]' | sed 's/^-//'
}

function mcc_fs_list_sync() {
    local LIST="$1" DEST="$2"; shift 2

    rsync ${MCC_FS_RSYNC_OPTS[@]} --files-from "$LIST" / "$DEST/" $@
}
