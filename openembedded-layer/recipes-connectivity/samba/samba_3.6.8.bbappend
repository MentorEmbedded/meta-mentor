PRINC := "${@int(PRINC) + 1}"
EXTRA_OECONF += "\
    --disable-avahi \
    --without-acl-support \
"
