remove_systemd_bind () {
        if [ -L ${IMAGE_ROOTFS}/etc/systemd/system/local-fs.target.wants/var-volatile-systemd.service ]; then
                rm ${IMAGE_ROOTFS}/etc/systemd/system/local-fs.target.wants/var-volatile-systemd.service
        fi
}
