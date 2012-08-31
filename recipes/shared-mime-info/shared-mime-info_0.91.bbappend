PRINC := "${@int(PRINC) + 1}"

# Add explicit link of libgthread-2.0
EXTRA_OECONF += "'GIO_LIBS=-lgio-2.0 -lgobject-2.0 -lglib-2.0 -lgthread-2.0'"
