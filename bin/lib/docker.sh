#!/bin/sh

# Abstracted away in case we want to use something else than docker at some point
# Podman / Buildah - I'm looking at you 😎

function docker_image_exists_locally() {
    local NAME="$1"; [[ ! -z "$(docker images -q "$NAME" 2>/dev/null)" ]]
}

function docker_image_get_digest() {
    local NAME="$1"; docker image inspect --format='{{index (.RepoDigests) 0}}' "$NAME"
}

function docker_image_get_size() {
    local NAME="$1"; docker image inspect --format='{{.Size}}' "$NAME"
}

function docker_image_get_id() {
    local NAME="$1"; docker image inspect --format='{{.Id}}' "$NAME"
}

function docker_image_pull() {
    local NAME="$1" FORCE_PULL=$2; docker_image_exists_locally "$NAME" && ! $FORCE_PULL || docker pull "$NAME"
}

function docker_build() {
    local CONTEXT_DIR="$1" NAME="$2"; shift 2

    (
        set -x
        docker build "$CONTEXT_DIR" \
            --tag "$NAME" \
            "$@"
    )
}

function docker_push() {
    local NAME="$1"; shift 1

    docker push "$NAME" $@
}