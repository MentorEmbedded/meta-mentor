# Add codepage437 to avoid error from `dosfsck -l`
RDEPENDS_${PN}_append_libc-glibc += "glibc-gconv-ibm437"
