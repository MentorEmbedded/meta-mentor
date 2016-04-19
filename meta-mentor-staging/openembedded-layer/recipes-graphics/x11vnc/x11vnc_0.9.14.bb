SUMMARY = "Exports your X session on-the-fly via VNC"
HOMEPAGE = "http://www.karlrunge.com/x11vnc/"

SECTION = "x11/utils"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://src/x11vnc.h;endline=30;md5=f7c5ca657517cffda77e7c65792b5af3"

FILESPATH .= ":${@bb.utils.which('${BBPATH}', 'recipes-graphics/x11vnc/files')}"
SRC_URI = "https://github.com/LibVNC/x11vnc/archive/${PV}.tar.gz;downloadfilename=${BPN}-${PV}.tar.gz \
           file://starting-fix.patch"

SRC_URI[md5sum] = "994de25a538ec24049734b26355aa8d5"
SRC_URI[sha256sum] = "45f87c5e4382988c73e8c7891ac2bfb45d8f9ce1196ae06651c84636684ea143"

DEPENDS = "openssl virtual/libx11 libxext libxi jpeg zlib libxfixes libxrandr libxdamage libxtst libtasn1 p11-kit libvncserver"

inherit autotools-brokensep distro_features_check pkgconfig
# depends on virtual/libx11
REQUIRED_DISTRO_FEATURES = "x11"

PACKAGECONFIG = "${@bb.utils.contains('DISTRO_FEATURES', 'zeroconf', 'avahi', '', d)}"
PACKAGECONFIG[avahi] = "--with-avahi,--without-avahi,avahi"
PACKAGECONFIG[xinerama] = "--with-xinerama,--without-xinerama,libxinerama"
