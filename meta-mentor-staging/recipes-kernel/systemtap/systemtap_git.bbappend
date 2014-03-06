SRC_URI += " \
    file://system_map_location.patch \
    file://define-em_aarch64-if-elf.h-doesnt.patch \
"

# Revert FILESPATH back to the default value, so FILESEXTRAPATHS is obeyed
FILESPATH = "${@base_set_filespath([ "${FILE_DIRNAME}/${PF}", "${FILE_DIRNAME}/${P}", "${FILE_DIRNAME}/${PN}", "${FILE_DIRNAME}/${BP}", "${FILE_DIRNAME}/${BPN}", "${FILE_DIRNAME}/files", "${FILE_DIRNAME}" ], d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}/systemtap:"
