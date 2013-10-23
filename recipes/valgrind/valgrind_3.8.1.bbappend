FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://do_not_include_linux_ptrace.patch \
            file://Update_configure_machinery_to_detect_PTRACE_GETREGS.patch \
          "

