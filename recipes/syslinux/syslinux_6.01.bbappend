inherit siteinfo

# gcc 4.1 on CentOS 5.x hosts doesn't define __SIZEOF_POINTER__
SIZEOF_POINTER = "${@'8' if SITEINFO_BITS == '64' else '4'}"
CFLAGS_append_class-native = "\
    -D__SIZEOF_POINTER__=${SIZEOF_POINTER} \
"

EXTRA_OEMAKE += "\
    'CC=${CC} ${CFLAGS}' \
    'LD=${LD} ${@LDFLAGS.replace('-Wl,', '').replace(',', '=')}' \
"
