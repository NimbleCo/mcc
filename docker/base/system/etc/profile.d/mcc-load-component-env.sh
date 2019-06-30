#!/bin/bash

set -e

[[ ! -z "${MCC_PREFIX}" ]] || MCC_PREFIX="/usr"

. "${MCC_PREFIX}/lib/mcc/cfg.sh"

[[ -d "$MCC_COMPONENT_MANIFESTS_DIR" ]] || return 0

#(cat "$MCC_COMPONENT_MANIFESTS_DIR/"*"/runtime-env" || true) | sed -E 's/^([^=]+=[^\s$]+)/export \1/' > "$MCC_TMPDIR/runtime-env"

#. "$MCC_TMPDIR/runtime-env"



