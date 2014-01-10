# Make sure we include lttng 0.x tools for machines on old kernels which are
# patched for lttng 0.x.
OVERRIDES .= "${@':lttng0x' if 'lttng0x' in MACHINE_FEATURES.split() else ''}"

LTTNGUST_lttng0x = "lttng0-ust"
LTTNGTOOLS_lttng0x = "lttng-control"
LTTNGMODULES_lttng0x = ""
BABELTRACE_lttng0x = ""
