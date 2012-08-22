AVAILABLE_KNOBS += "\
    audio \
    benchmark \
    bluetooth \
    framebuffer \
    host-diskdrive \
    host-usb \
    nas \
    print-server \
    router \
    tests \
    wifi \
    x11-minimal \
    \
    ${@base_contains('MACHINE_FEATURES', 'lttng', 'lttng', '', d)} \
    ${@base_contains('MACHINE_FEATURES', 'lttng2', 'lttng2', '', d)} \
"

PACKAGE_GROUP_sb-base = '\
    base-files base-passwd busybox-httpd openssh openssh-sftp-server \
    modutils-initscripts netbase update-alternatives update-rc.d gdbserver \
    kernel-vmlinux kernel-modules procps psmisc crashme ethtool \
    oprofile strace tcpdump sysstat net-tools util-linux \
'

PACKAGE_GROUP_lttng              = 'lttng-control lttng-ust'
PACKAGE_GROUP_lttng2             = 'lttng-tools lttng-modules lttng2-ust'

VALGRIND ?= ""
VALGRIND_powerpc ?= "valgrind"
VALGRIND_powerpc64 ?= "valgrind"
PACKAGE_GROUP_native-development = '\
    gcc gcc-symlinks g++ g++-symlinks cpp cpp-symlinks ldd \
    binutils binutils-symlinks gdb linux-libc-headers file bash \
    perl-modules libtool libtool-dev libltdl-dev \
    make virtual-libc-dev bison flex libstdc++-dev automake autoconf \
    m4 u-boot-mkimage dtc ${VALGRIND} \
'

# For compatibility
PACKAGE_GROUP_audio           = 'alsa-utils'
PACKAGE_GROUP_audio+bluetooth = 'libasound-module-bluez'
PACKAGE_GROUP_benchmark       = 'task-tools-benchmark'
PACKAGE_GROUP_bluetooth       = 'task-base-bluetooth'
PACKAGE_GROUP_host-diskdrive  = 'task-base-ext2 e2fsprogs-tune2fs e2fsprogs-badblocks mdadm'
PACKAGE_GROUP_host-usb        = 'task-base-ext2 e2fsprogs-tune2fs e2fsprogs-badblocks'
PACKAGE_GROUP_inflexion       = 'libpng'
PACKAGE_GROUP_framebuffer     = 'psplash'
PACKAGE_GROUP_wifi            = 'task-base-wifi'
PACKAGE_GROUP_x11-minimal     = '${PACKAGE_GROUP_x11-mini}'
PACKAGE_GROUP_tests              = ''
