PRINC := "${@int(PRINC) + 1}"

LICENSE = 'GPL-2.0+'
SRCREV = 'a270c14424292a6e34312130e1f2fa44ccace9f8'
PV = '1.0.0+git${SRCPV}'

SRC_URI = 'git://github.com/MentorEmbedded/boot-format'

EXTRA_OEMAKE += '"CFLAGS=${CFLAGS} ${LDFLAGS}"'
