FILESEXTRAPATHS_prepend := "${THISDIR}/lttng-modules:"

SRC_URI_append = " file://work-around_upstream_Linux_timekeeping_bug.patch \
                   file://show_warning_for_broken_clock_workaround.patch \
                   file://nmi-safe_clock_on_32-bit_systems.patch \
"
