SUMMARY = "User interface to Ftrace"
LICENSE = "GPLv2 & LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=751419260aa954499f7abaabaa882bbe \
"
SRCREV = "79e08f8edb38c4c5098486caaa87ca90ba00f547"

PV = "2.3.2+git${SRCPV}"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git;protocol=git;branch=trace-cmd-stable-v2.3 \
"
S = "${WORKDIR}/git"

inherit pkgconfig pythonnative

EXTRA_OEMAKE = "\
    'prefix=${prefix}' \
    'bindir=${bindir}' \
    'man_dir=${mandir}' \
    'html_install=${datadir}/kernelshark/html' \
    'img_install=${datadir}/kernelshark/html/images' \
    \
    'bindir_relative=${@oe.path.relative(prefix, bindir)}' \
    'libdir=${@oe.path.relative(prefix, libdir)}' \
    \
    NO_PYTHON=1 \
"

do_install() {
	oe_runmake DESTDIR="${D}" install
}

FILES_${PN}-dbg += "${libdir}/trace-cmd/plugins/.debug"
