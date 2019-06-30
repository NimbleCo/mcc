#!/bin/bash

set -e

[[ ! -z "${MCC_PREFIX}" ]] || MCC_PREFIX="/usr"

. "${MCC_PREFIX}/lib/mcc/cfg.sh"

[[ -d "$MCC_COMPONENT_MANIFESTS_DIR" ]] || return 0

source "$MCC_COMPONENT_MANIFESTS_DIR/"*"/runtime-env"





