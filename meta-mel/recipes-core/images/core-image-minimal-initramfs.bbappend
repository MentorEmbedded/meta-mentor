PACKAGE_INSTALL = "initramfs-boot iperf iptables busybox udev base-passwd dosfstools ${ROOTFS_BOOTSTRAP_INSTALL} ${FEATURE_INSTALL}"
IMAGE_FEATURES = " codebench-debug"

COMPATIBLE_HOST = "(arm|aarch64|i.86|x86_64).*-linux"

IMAGE_FSTYPES_remove = "wic.bmap"
