DEPENDS += "attr"

do_configure_p1010rdb() {
    qemu_binary="${@qemu_target_binary(d)}"
    if [ ${qemu_binary} == "qemu-allarch" ]; then
        qemu_binary="qemuwrapper"
    fi

    libdir_qemu="${STAGING_DIR_HOST}/${libdir}"
    base_libdir_qemu="${STAGING_DIR_HOST}/${base_libdir}"

    CROSS_EXEC="${qemu_binary} \
                -L ${STAGING_DIR_HOST} \
                -E LD_LIBRARY_PATH=${libdir_qemu}:${base_libdir_qemu}"

    if [ ${qemu_binary} != "qemuwrapper" ]; then
        CROSS_EXEC="${CROSS_EXEC} ${QEMU_OPTIONS}  ${QEMU_EXTRAOPTIONS}"
    fi

    export BUILD_SYS=${BUILD_SYS}
    export HOST_SYS=${HOST_SYS}
    export BUILD_ARCH=${BUILD_ARCH}
    export HOST_ARCH=${HOST_ARCH}
    export STAGING_LIBDIR=${STAGING_LIBDIR}
    export STAGING_INCDIR=${STAGING_INCDIR}
    export PYTHONPATH=${STAGING_DIR_HOST}${PYTHON_SITEPACKAGES_DIR}

    ./configure ${CONFIGUREOPTS} ${EXTRA_OECONF} --cross-compile --cross-execute="${CROSS_EXEC}"
}
