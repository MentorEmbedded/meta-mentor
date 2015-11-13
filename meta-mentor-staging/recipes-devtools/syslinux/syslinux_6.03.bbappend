# Obey our vars for binutils
EXTRA_OEMAKE += "\
    'LD=${LD}' 'RANLIB=${RANLIB}' 'STRIP=${STRIP}' \
    'NM=${NM}' 'AR=${AR}' 'OBJCOPY=${OBJCOPY}' 'OBJDUMP=${OBJDUMP}' \
"
