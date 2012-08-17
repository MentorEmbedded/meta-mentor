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

SWAN ?= "strongswan"
XSERVER ?= "xserver-xorg xf86-input-evdev xf86-input-mouse xf86-input-keyboard xf86-video-fbdev"

PACKAGE_GROUP_sb-base = '\
    base-files base-passwd busybox-httpd openssh openssh-sftp-server \
    modutils-initscripts netbase update-alternatives update-rc.d gdbserver \
    kernel-vmlinux kernel-modules procps psmisc crashme ethtool \
    oprofile strace tcpdump sysstat net-tools util-linux \
'
PACKAGE_GROUP_audio = '\
    alsa-utils \
    alsa-utils-alsamixer \
    alsa-utils-midi \
    alsa-utils-aplay \
    alsa-utils-amixer \
    alsa-utils-aconnect \
    alsa-utils-iecset \
    alsa-utils-speakertest \
    alsa-utils-aseqnet \
    alsa-utils-aseqdump \
    alsa-utils-alsaconf \
    alsa-utils-alsactl \
'
PACKAGE_GROUP_audio+bluetooth    = 'libasound-module-bluez'
PACKAGE_GROUP_benchmark = '\
    bonnie++ netperf netperf-doc lmbench iozone3 iperf \
    dbench tbench tiobench tiobench-doc \
'
PACKAGE_GROUP_bluetooth          = 'bluez4'

PACKAGE_GROUP_framebuffer        = 'psplash'
PACKAGE_GROUP_host-diskdrive = '\
    e2fsprogs-e2fsck e2fsprogs-mke2fs e2fsprogs-tune2fs \
    e2fsprogs-badblocks mdadm \
'
PACKAGE_GROUP_host-usb = '\
    e2fsprogs-e2fsck e2fsprogs-mke2fs e2fsprogs-tune2fs \
    e2fsprogs-badblocks \
'
PACKAGE_GROUP_lttng              = 'lttng-control lttng-ust'
PACKAGE_GROUP_lttng2             = 'lttng-tools lttng-modules lttng2-ust'
PACKAGE_GROUP_nas                = 'samba swat tzdata nfs-utils rpcbind'

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

PACKAGE_GROUP_print-server       = 'samba swat'
PACKAGE_GROUP_router             = '\
    ${SWAN} \
    ipsec-tools iproute2 iptables tcp-wrappers rng-tools \
    ppp rp-pppoe \
'

PACKAGE_GROUP_tests              = ''
PACKAGE_GROUP_wifi               = 'wireless-tools wpa-supplicant'

PACKAGE_GROUP_inflexion          = 'libpng'

# For compatibility
PACKAGE_GROUP_x11-minimal        = '${PACKAGE_GROUP_x11-mini}'
