FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://x32_support.patch"

# JIT not supported on X32
# An attempt was made to upstream JIT support for x32 in
# https://bugs.webkit.org/show_bug.cgi?id=100450, but this was closed as
# unresolved due to limited X32 adoption.
EXTRA_OECMAKE_append_linux-gnux32 = " -DENABLE_JIT=OFF"
