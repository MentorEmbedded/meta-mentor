# To enable: add to INHERIT. This will be used for recipes inheriting kernel,
# but not those inheriting kernel-yocto.
#
# To use: in a bbappend or recipe, add config snippets with filenames *.cfg
# to SRC_URI. these will be concatenated to the end of the defconfig, assuming
# DEFCONFIG or KERNEL_DEFCONFIG is correct.

DEFCONFIG ?= "${WORKDIR}/defconfig"
KERNEL_DEFCONFIG ?= "${DEFCONFIG}"

append_fragments () {
    if [ -z "${KERNEL_DEFCONFIG}" ] || [ ! -e "${KERNEL_DEFCONFIG}" ]; then
        return 0
    fi

    for fragment in ${WORKDIR}/*.cfg; do
        if [ -e $fragment ] || [ -L $fragment ]; then
            while read line; do
                CONFIG="${line%=*}"
                DEF_GREP=`awk "/\<${CONFIG}\>/" "${KERNEL_DEFCONFIG}" `
                RC=$?
                if [ 0 = $RC ] && [ -n "${DEF_GREP}" ]; then
                    sed -i "s/${DEF_GREP}/${line}/g" ${KERNEL_DEFCONFIG}
                else
                    echo ${line} >> ${KERNEL_DEFCONFIG}
                fi
            done < $fragment
        fi
    done
    CONF_DIR=`dirname ${KERNEL_DEFCONFIG}`
    rm -f ${CONF_DIR}/sed*
}

python () {
    if oe.utils.inherits(d, 'kernel') and not oe.utils.inherits(d, 'kernel-yocto'):
        d.appendVarFlag('do_patch', 'postfuncs', ' append_fragments')
        d.appendVarFlag('do_patch', 'vardeps', ' append_fragments')
}
