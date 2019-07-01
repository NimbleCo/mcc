BUILT_IMAGES=""
BUILD_ARGS=""

function on_exit() {
    [[ -z "$TMP_DIR" ]] || rm -rf "$TMP_DIR"
}

trap on_exit EXIT

function get_target_image_base_name() {
    echo "${TARGET_VENDOR}/mcc-${1}"
}

function get_target_image_name() {
    local NAME="$1"
    local FULL_NAME="$(get_target_image_base_name "$NAME")"

    [[ ! -z "$TARGET_TAG" ]] && FULL_NAME="$FULL_NAME:$TARGET_TAG" || true

    echo "$FULL_NAME"
}

function get_target_image_id_file() {
    local NAME="$1"; echo "${TMP_DIR}/${NAME}.iid"
}

function normalize_to_arg_name() {
    echo "$@" | tr a-z A-Z | sed -E 's/[^_A-Z0-9]+/_/g'
}

function register_local_image() {
    local NAME="$1" DIGEST="$2"
    local ARG_NAME="$(normalize_to_arg_name "$NAME")_IMAGE"

    BUILD_ARGS="${BUILD_ARGS} --build-arg ${ARG_NAME}=${DIGEST}"
}

function register_target_image() {
    local LOCAL_NAME="$1" TARGET_NAME="$2" DIGEST="$3"

    local B_SIZE=`docker_image_get_size "$DIGEST"`
    local H_SIZE=`printf "%d MiB" $((B_SIZE / 1024 / 1024))`

    BUILT_IMAGES="$BUILT_IMAGES$(printf "%-30s  %-50s  %10s" "$LOCAL_NAME" "$TARGET_NAME" "$H_SIZE")  $DIGEST\n"
}

function pull_base_image() {
    local LOCAL_NAME="$1" REMOTE_NAME="$2"

    log_task_start "PULL:$LOCAL_NAME"

    docker_image_pull "$REMOTE_NAME" ${FORCE_PULL}

    local DIGEST=`docker_image_get_digest "$REMOTE_NAME"`

    log_task_success "PULL:$LOCAL_NAME" "=> $REMOTE_NAME | $DIGEST"

    register_local_image "$LOCAL_NAME" "$DIGEST"
    register_target_image "$LOCAL_NAME" "$REMOTE_NAME" "$DIGEST"
}

function build_local_image() {
    local LOCAL_NAME="$1"
    local TARGET_NAME="$2"
    local TARGET_BASE_NAME="$(get_target_image_base_name "$LOCAL_NAME")"

    shift 2

    local CONTEXT="$DOCKER_DIR/$LOCAL_NAME"
    local IID_FILE=`get_target_image_id_file "$LOCAL_NAME"`

    docker_build "$CONTEXT" "$TARGET_NAME" --iidfile "$IID_FILE" ${BUILD_ARGS} $@

    DIGEST="$(cat "$IID_FILE")"
}

function build_target_image() {
    local LOCAL_NAME="$1"
    local TARGET_NAME=`get_target_image_name "$1"`
    shift 1

    log_task_start "BUILD:$LOCAL_NAME" "=> $TARGET_NAME"

    build_local_image "$LOCAL_NAME" "$TARGET_NAME" $@

    register_local_image "$LOCAL_NAME" "$DIGEST"
    register_target_image "$LOCAL_NAME" "$TARGET_NAME" "$DIGEST"

    log_task_success "BUILD:$LOCAL_NAME" "=> $TARGET_NAME | $DIGEST"
}

function build_target_stage() {
    local LOCAL_NAME="$1" STAGE="$2" TARGET_NAME=`get_target_image_name "$1.$2"` ; shift 2

    log_task_start "BUILD_STAGE.$LOCAL_NAME.$STAGE" "=> $TARGET_NAME"

    build_local_image "$LOCAL_NAME" "$TARGET_NAME" --target "$STAGE" $@

    register_local_image "$LOCAL_NAME.$STAGE" "$DIGEST"
    register_target_image "$LOCAL_NAME.$STAGE" "$TARGET_NAME" "$DIGEST"

    log_task_success "BUILD_STAGE:$LOCAL_NAME.$STAGE" "=> $TARGET_NAME | $DIGEST"
}

function push_built_images {
    echo -e "$BUILT_IMAGES" | grep " $TARGET_VENDOR/" | sed 's/ \{1,\}/ /g' | while read CONTAINER_INFO; do
        local LOCAL_NAME="$(echo "$CONTAINER_INFO" | cut -d' ' -f 1)"
        local TARGET_NAME="$(echo "$CONTAINER_INFO" | cut -d' ' -f 2)"

        docker_push "$TARGET_NAME"

        log_task_success "PUSH:$LOCAL_NAME" "=> $TARGET_NAME"
    done
}