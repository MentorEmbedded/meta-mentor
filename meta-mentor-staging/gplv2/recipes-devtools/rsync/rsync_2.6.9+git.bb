# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

require recipes-devtools/rsync/rsync_2.6.9.bb

SRC_URI = "git://git.samba.org/rsync.git;protocol=https;branch=master \
           file://rsyncd.conf \
           file://addrinfo.h \
           file://0001-If-we-re-cross-compiling-tell-the-user-to-run-mkroun.patch \
           file://0002-Changed-the-creation-of-rounding.h-to-use-a-set-of-c.patch \
           file://0003-Renamed-mkrounding.c-to-rounding.c.patch \
           file://0004-Improved-the-manpage-install-rules.patch \
           file://force-protocol-version-29.patch \
"

SRCREV = "496c809f8cf529c5a95f9578b34a9299b0d92ffb"
PV .= "${SRCPV}"

S = "${WORKDIR}/git"

do_configure:prepend () {
    install ${WORKDIR}/addrinfo.h ${S}/lib/
}

do_configure:append () {
    oe_runmake proto
}
