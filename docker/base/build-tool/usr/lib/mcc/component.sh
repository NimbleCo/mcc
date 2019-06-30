function mcc_component_get_manifest_dir() {
    local COMPONENT_NAME="$1"

    echo "${MCC_COMPONENT_MANIFESTS_DIR}/${COMPONENT_NAME}"
}

function mcc_component_get_iout_dir() {
    local COMPONENT_NAME="$1"

    echo "$MCC_COMPONENT_IOUT_DIR/$COMPONENT_NAME"
}

function mcc_component_get_iout_tmp_dir() {
    local COMPONENT_NAME="$1"

    echo "$(mcc_component_get_iout_dir "$COMPONENT_NAME")${MCC_COMPONENT_IOUT_TMP_DIR}"
}

function mcc_component_get_iout_rfs_dir() {
    local COMPONENT_NAME="$1"

    echo "$(mcc_component_get_iout_dir "$COMPONENT_NAME")${MCC_COMPONENT_IOUT_RFS_DIR}"
}

function mcc_component_get_iout_manifest_dir() {
    local COMPONENT_NAME="$1"

    echo "$(mcc_component_get_iout_rfs_dir "$COMPONENT_NAME")$(mcc_component_get_manifest_dir "$COMPONENT_NAME")"
}

function mcc_component_iout_vars() {
    IOUT_COMPONENT_NAME="$1"

    IOUT_DIR=`mcc_component_get_iout_dir "$IOUT_COMPONENT_NAME"`
    IOUT_TMP_DIR=`mcc_component_get_iout_tmp_dir "$IOUT_COMPONENT_NAME"`
    IOUT_RFS_DIR=`mcc_component_get_iout_rfs_dir "$IOUT_COMPONENT_NAME"`
    IOUT_MANIFEST_DIR=`mcc_component_get_iout_manifest_dir "$IOUT_COMPONENT_NAME"`

    IOUT_METADATA_FILE="$IOUT_MANIFEST_DIR/metadata"

    IOUT_FS_LIST_BEGIN="$IOUT_TMP_DIR/fs-list-begin"
    IOUT_FS_LIST_FINISH="$IOUT_TMP_DIR/fs-list-finish"
    IOUT_FS_LIST_OUT="$IOUT_MANIFEST_DIR/filesystem"

    IOUT_RUNTIME_ENV_BEGIN="$IOUT_TMP_DIR/env-list-begin"
    IOUT_RUNTIME_ENV_FINISH="$IOUT_TMP_DIR/env-list-finish"
    IOUT_RUNTIME_ENV_OUT="$IOUT_MANIFEST_DIR/runtime-env"
}

function mcc_component_iout_cleanup() {
    local IOUT_COMPONENT_NAME="$1"

    [[ -z "$IOUT_COMPONENT_NAME" ]] || rm -rf `mcc_component_get_iout_tmp_dir "$IOUT_COMPONENT_NAME"`
}

function mcc_component_iout_begin() {
    mcc_component_iout_vars "$1"

    mkdir -p \
        "$IOUT_DIR" \
        "$IOUT_TMP_DIR" \
        "$IOUT_RFS_DIR" \
        "$IOUT_MANIFEST_DIR"

    log_task "Write begin fs list: $IOUT_FS_LIST_BEGIN" mcc_fs_list '>' "$IOUT_FS_LIST_BEGIN"
    log_task "Write begin env: $IOUT_RUNTIME_ENV_BEGIN" mcc_env_list '>' "$IOUT_RUNTIME_ENV_BEGIN"
    log_file_contents "$IOUT_RUNTIME_ENV_BEGIN"
}

function mcc_component_write_metadata() {
    local COMPONENT_NAME="$1" METADATA_FILE="$2"

    echo "MCC_COMPONENT_NAME=\"$COMPONENT_NAME\"" > "$METADATA_FILE"
}

function mcc_component_iout_finish() {
    mcc_component_iout_vars "$1"

    if [[ ! -d "$IOUT_DIR" ]] ; then
        log_error "Could not find output intermediary data dir ($IOUT_DIR), did you forget to run `mcc component-begin`?"
        exit 10
    fi

    log_task "Write finish env"  mcc_env_list '>' "$IOUT_RUNTIME_ENV_FINISH"
    log_file_contents "$IOUT_RUNTIME_ENV_FINISH"

    log_task "Write runtime env" mcc_env_list_diff "$IOUT_RUNTIME_ENV_BEGIN" "$IOUT_RUNTIME_ENV_FINISH" '|' mcc_diff_filter_new '|' mcc_env_add_exports '>' "$IOUT_RUNTIME_ENV_OUT"
    log_file_contents "$IOUT_RUNTIME_ENV_OUT"

    # TODO: Need to check files that were present both before and after and compute checksums, and warn if changed.

    log_task "Write finish fs list: $IOUT_FS_LIST_FINISH" mcc_fs_list '>' "$IOUT_FS_LIST_FINISH"

    log_task "Write output fs list" mcc_fs_list_diff "$IOUT_FS_LIST_BEGIN" "$IOUT_FS_LIST_FINISH" '|' mcc_diff_filter_new '>' "$IOUT_FS_LIST_OUT"
    log_file_contents "$IOUT_FS_LIST_OUT"

    log_task "Write component root fs: $IOUT_RFS_DIR" mcc_fs_list_sync "$IOUT_FS_LIST_OUT" "$IOUT_RFS_DIR"

    log_task "Write component metadata" mcc_component_write_metadata "$IOUT_COMPONENT_NAME" "$IOUT_METADATA_FILE"
    log_file_contents "$IOUT_METADATA_FILE"

    mcc_component_iout_cleanup "$IOUT_COMPONENT_NAME"
}




