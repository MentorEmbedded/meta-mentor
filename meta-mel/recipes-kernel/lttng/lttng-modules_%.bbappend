FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = "  \
                    file://lttng-module-fix-writeback-Fix-sync.patch \
                    file://0001-fix-random-tracepoints-removed-in-stable-kernels.patch \
"
