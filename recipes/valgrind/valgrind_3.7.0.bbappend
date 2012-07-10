export PERL="/usr/bin/env perl"
PR = "r3"

SRC_URI += "file://vg-ppc-feature.patch"
COMPATIBLE_HOST = "^(i.86|x86_64|powerpc).*-linux"
FILESEXTRAPATHS_append := ":${THISDIR}"
DEPENDS = "${@base_contains('DISTRO_FEATURES', 'x11', 'virtual/libx11', '', d)}"
