PACKAGECONFIG ?= "\
    ${@base_contains('DISTRO_FEATURES', 'acl', 'acl', '', d)} \
    ${@base_contains('DISTRO_FEATURES', 'selinux', 'selinux', '', d)} \
"

# If RPM_OPT_FLAGS is unset, it adds -g itself rather than obeying our
# optimization variables, so use it rather than EXTRA_CFLAGS.
EXTRA_OEMAKE = "\
    LFS= \
    OS_NAME='${OS_NAME}' \
    \
    'CC=${CC}' \
    'RPM_OPT_FLAGS=${CFLAGS}' \
    'EXTRA_LDFLAGS=${LDFLAGS}' \
    \
    ${@base_contains('PACKAGECONFIG', 'acl', 'WITH_ACL=yes', '', d)} \
    ${@base_contains('PACKAGECONFIG', 'selinux', 'WITH_SELINUX=yes', '', d)} \
"

# OS_NAME in the makefile defaults to `uname -s`. The behavior for
# freebsd/netbsd is questionable, so leave it as Linux, which only sets
# INSTALL=install and BASEDIR=/usr.
OS_NAME = "Linux"

# TODO: add BINDIR=${bindir} to the oe_runmake install line in do_install
