SSTATE_POSTPROCESS_FUNCS ?= ""

sstate_create_package[postfuncs] += "sstate_postprocess"

sstate_postprocess () {
    for func in ${SSTATE_POSTPROCESS_FUNCS}; do
        eval $func ${SSTATE_PKG}
    done
}
