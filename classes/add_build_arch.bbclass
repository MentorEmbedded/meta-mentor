# Add an explicit -march to BUILD_CFLAGS. sanity.bbclass will fail on gcc
# versions older than 4.5 without -march= in BUILD_CFLAGS.
python add_build_march () {
    arch_args = {
        "i586": "i586",
        "i686": "i686",
        "x86_64": "x86-64",
    }
    build_cflags = e.data.getVar("BUILD_CFLAGS", True)
    build_arch = e.data.getVar("BUILD_ARCH", True)
    if '-march' not in build_cflags and build_arch in arch_args:
        e.data.appendVar("BUILD_CFLAGS", " -march={0}".format(arch_args[build_arch]))
}
add_build_march[eventmask] = "bb.event.ConfigParsed"
addhandler add_build_march
