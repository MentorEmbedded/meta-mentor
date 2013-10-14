LDFLAGS = "${@TARGET_LDFLAGS}"
LDFLAGS_class-native = "${@BUILD_LDFLAGS}"

EXTRA_OEMAKE += "\
    'CC=${CC}' \
    'LD=${LD}' \
"
