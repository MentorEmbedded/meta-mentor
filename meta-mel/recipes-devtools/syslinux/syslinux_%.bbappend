inherit siteinfo

SIZEOF_POINTER = "${@'8' if SITEINFO_BITS == '64' else '4'}"

# It appears that the syslinux buildsystem passes -march=i386 even on 64 bit
# x86 hosts, so we need to pass this as 4 in the x86_64 case too. We should
# look into why syslinux sets its own tuning.
SIZEOF_POINTER_x86-64 = "4"

# gcc 4.1 on CentOS 5.x hosts doesn't define __SIZEOF_POINTER__
CFLAGS_append_class-native_mel = " -D__SIZEOF_POINTER__=${SIZEOF_POINTER}"
