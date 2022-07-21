# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# do not use connman as a DNS proxy because both dnsmasq and connman try to
# bind to same port 53.
do_install:append:mel () {
    sed -i '/^ExecStart=/ s@-n@--nodnsproxy -n@g' ${D}${systemd_unitdir}/system/connman.service
}
