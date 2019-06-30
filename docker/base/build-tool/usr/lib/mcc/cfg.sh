# Attempt to load local configs, order narrows the scope allowing overrides
[[ ! -f "/etc/mcc.conf" ]]   || source "/etc/mcc.conf"
[[ ! -f "~/.mcc.conf" ]]     || source "~/mcc.conf"
[[ ! -f "$PWD/mcc.conf" ]]   || source "$PWD/mcc.conf"

# Global core defaults, you will almost never override these (maybe except for some testing)
[[ ! -z "$MCC" ]]            || MCC="mcc"
[[ ! -z "$MCC_TMPDIR" ]]     || MCC_TMPDIR="/tmp/mcc"

# Installed components' manifest system-global storage directory
[[ ! -z "$MCC_COMPONENT_MANIFESTS_DIR" ]] || MCC_COMPONENT_MANIFESTS_DIR="/etc/mcc.components.d"

# Intermediary build stage (component-finish) component artifact storage dir ("iout" stands for "intermediary output")
[[ ! -z "$MCC_COMPONENT_IOUT_DIR" ]]      || MCC_COMPONENT_IOUT_DIR="/component"

# Name of the intermediary rootfs storage dir
[[ ! -z "$MCC_COMPONENT_IOUT_RFS_DIR" ]]  || MCC_COMPONENT_IOUT_RFS_DIR="/rootfs"

# Name of the intermediary temp data storage dir
[[ ! -z "$MCC_COMPONENT_IOUT_TMP_DIR" ]]  || MCC_COMPONENT_IOUT_TMP_DIR="/tmp"

# Common opts for `diff` command
[[ ! -z "$MCC_DIFF_OPTS" ]] || MCC_DIFF_OPTS=(
     "--text"
     "--suppress-blank-empty"
     "--ignore-blank-lines"
     "--ignore-trailing-space"
     "--color=never"
     "--unchanged-line-format=%l%c'\012'"
     "--old-line-format=-%l%c'\012'"
     "--new-line-format=+%l%c'\012'"
)

# Common opts for `rsync` command
[[ ! -z "$MCC_FS_RSYNC_OPTS" ]] || MCC_FS_RSYNC_OPTS=(
    "--verbose"
    "--links"
    "--perms"
    "--executability"
    "--acls"
    "--xattrs"
    "--owner"
    "--group"
    "--devices"
    "--specials"
    "--times"
)

# Paths to exclude while computing component build filesystem diff
[[ ! -z "$MCC_FS_EXCLUDES" ]]   || MCC_FS_EXCLUDES=(
    "/tmp"
    "/lib/apk"
    "/var/cache"
    "/var/log"
    "/etc/apk/world"
    "/root"
)

# Always exclude the MCC temporary directory
MCC_FS_EXCLUDES=("${MCC_TMPDIR}" "${MCC_COMPONENT_IOUT_DIR}" "${MCC_FS_EXCLUDES[@]}")

