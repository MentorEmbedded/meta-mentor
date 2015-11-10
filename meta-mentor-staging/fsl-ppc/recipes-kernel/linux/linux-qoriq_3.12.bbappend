FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://powerpc_align_TOC_to_256_bytes.patch"

SRC_URI_append_t4240rdb-64b = " file://0001-powerpc-module-avoid-memmove-in-dedotify.patch"
