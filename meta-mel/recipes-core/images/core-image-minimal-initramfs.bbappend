PACKAGE_INSTALL_mel = "iperf2 iptables busybox udev base-passwd dosfstools ${ROOTFS_BOOTSTRAP_INSTALL} ${FEATURE_INSTALL}"
IMAGE_FEATURES_mel = "codebench-debug ssh-server-openssh"

COMPATIBLE_HOST_mel = "(arm|aarch64|i.86|x86_64).*-linux"

IMAGE_FSTYPES_remove_mel = "wic.bmap"
