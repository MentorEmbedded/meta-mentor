SUMMARY = "User interface to Ftrace"
LICENSE = "GPLv2 & LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=751419260aa954499f7abaabaa882bbe \
"
SRCREV = "79e08f8edb38c4c5098486caaa87ca90ba00f547"

PV = "2.3.2+git${SRCPV}"

inherit pkgconfig pythonnative

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git;protocol=git;branch=trace-cmd-stable-v2.3 \
"
S = "${WORKDIR}/git"

EXTRA_OEMAKE = "'prefix=${prefix}' NO_PYTHON=1"

FILES_${PN}-dbg += "${datadir}/trace-cmd/plugins/.debug/"

do_install() {
	oe_runmake prefix="${prefix}" DESTDIR="${D}" install
}


