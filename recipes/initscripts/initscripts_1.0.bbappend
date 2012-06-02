PRINC := "${@int(PRINC) + 1}"

do_unpack[postfuncs] += "fixup_volatiles"

fixup_volatiles () {
    sed -i 's/eval \$EXEC &/eval \$EXEC/' ${WORKDIR}/populate-volatile.sh
}
