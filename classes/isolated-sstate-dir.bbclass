# Use an isolated per-build SSTATE_DIR while still populating a shared sstate
# directory for use across multiple builds.

SHARED_SSTATE_DIR := "${SSTATE_DIR}"
SSTATE_DIR = "${TMPDIR}/sstate-cache"
SSTATE_MIRRORS += "file://.* file://${SHARED_SSTATE_DIR}/PATH \n "

sstate_create_package_append () {
    if [ "${SSTATE_DIR}" != "${SHARED_SSTATE_DIR}" ]; then
        shared_pkg=$(echo ${SSTATE_PKG} | sed 's,^${SSTATE_DIR}/,${SHARED_SSTATE_DIR}/,')
        mkdir -p $(dirname $shared_pkg)
        mv ${SSTATE_PKG} $shared_pkg
        ln -sf $shared_pkg ${SSTATE_PKG}
    fi
}
