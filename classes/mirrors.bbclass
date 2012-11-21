PREMIRRORS_append = " \
git://sources.redhat.com/ git://sourceware.org/ \n\
"

MIRRORS += "\
git://git.kernel.org/pub/ http://mirror.nexcess.net/kernel.org/ \n\
${APACHE_MIRROR}/ http://archive.apache.org/dist/ \n\
${DEBIAN_MIRROR}/ ftp://archive.debian.org/debian/pool/ \n\
${KERNELORG_MIRROR}/ https://kernel.googlesource.com/ \n\
${KERNELORG_MIRROR}/ http://mirror.nexcess.net/kernel.org/ \n\
${KERNELORG_MIRROR}/ http://mirror.gbxs.net/pub/ \n\
.*://.*/.* http://downloads.yoctoproject.org/mirror/sources/ \n\
.*://.*/.* http://www.angstrom-distribution.org/unstable/sources/ \n\
.*://.*/.* http://autobuilder.yoctoproject.org/sources/ \n\
.*://.*/.* http://sources.openembedded.org/ \n\
"
