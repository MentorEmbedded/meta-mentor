do_install_append_feature-mentor-staging () {
        chown -R root:root ${D}${datadir}/jamvm/classes.zip
}

