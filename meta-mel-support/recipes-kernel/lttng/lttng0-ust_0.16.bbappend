SRC_URI += "file://enable-clock-trace-for-userspace-tracing.patch"
FILESEXTRAPATHS_prepend := "${THISDIR}/lttng-ust:"
COMPATIBLE_HOST = '(x86_64.*|i.86.*|arm.*|powerpc.*|mips.*)-linux.*'
