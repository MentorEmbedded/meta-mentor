# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# If build system has 8 or less CPU cores, build only 8 jobs in parallel
PARALLEL_MAKE:mel = "-j ${@'8' if oe.utils.cpu_count() <= 8 else oe.utils.cpu_count() * 2}"
