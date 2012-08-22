inherit task

DEFAULT_PREFERENCE = "-1"

DESCRIPTION = "Tasks for the Linux Trace Toolkit tools v2.0"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PR = "r1"

RDEPENDS_${PN} += "lttng-tools lttng-modules lttng2-ust"
