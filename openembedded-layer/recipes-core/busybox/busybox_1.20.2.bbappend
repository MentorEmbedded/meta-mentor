PRINC := "${@int(PRINC) + 3}"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://fbset.patch"

# Depend on fbset-modes if we have fbset support enabled
python () {
    try:
        defconfig = bb.fetch2.localpath('file://defconfig', d)
    except bb.fetch2.FetchError:
        return

    try:
        configfile = open(defconfig)
    except IOError:
        return

    if 'CONFIG_FBSET=y\n' in configfile.readlines():
        d.setVar('FBSET_DEP', 'fbset-modes')
}

FBSET_DEP = ""
RRECOMMENDS_${PN} += "${FBSET_DEP}"
