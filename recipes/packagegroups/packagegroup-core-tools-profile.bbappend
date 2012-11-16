PRINC := "${@int(PRINC) + 1}"

# Make sure we include lttng 0.x tools for machines on old kernels which are
# patched for lttng 0.x.
OVERRIDES .= "${@':lttng0x' if 'lttng0x' in MACHINE_FEATURES.split() else ''}"

LTTNGUST_lttng0x = "lttng-ust"
LTTNGTOOLS_lttng0x = "lttng-control"
LTTNGMODULES_lttng0x = ""
BABELTRACE_lttng0x = ""

# We patch liburcu for mips
LTTNGTOOLS_mips = "lttng-tools"
LTTNGMODULES_mips = "lttng-modules"
BABELTRACE_mips = "babeltrace"

# These aren't compatible with mips, so not mips64 either
VALGRIND_mips64 = ""
SYSTEMTAP_mips64 = ""
