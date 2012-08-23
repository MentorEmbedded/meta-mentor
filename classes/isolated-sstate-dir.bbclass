# Use an isolated per-build SSTATE_DIR while still populating a shared sstate
# directory for use across multiple builds.

SHARED_SSTATE_DIR := "${SSTATE_DIR}"
SSTATE_DIR = "${TMPDIR}/sstate-cache"
SSTATE_MIRRORS += "file://.* file://${SHARED_SSTATE_DIR}/PATH\n"

sstate_create_package_append () {
    outdir=${SHARED_SSTATE_DIR}/$(dirname ${SSTATE_PKGNAME})
    mkdir -p $outdir/
    mv ${SSTATE_PKG} $outdir/
    ln -sf ${SHARED_SSTATE_DIR}/${SSTATE_PKGNAME} ${SSTATE_PKG}
}
