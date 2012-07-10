PRINC := "${@int(PRINC) + 1}"
EXTRA_OECONF += "--with-fontrootdir=${datadir}/fonts/X11"
