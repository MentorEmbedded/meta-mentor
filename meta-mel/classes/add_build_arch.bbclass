# Add an explicit -march to BUILD_CFLAGS. sanity.bbclass will fail on gcc
# versions older than 4.5 without -march= in BUILD_CFLAGS.
python add_build_march () {
    d = e.data
    arch_args = {
        "i586": "i586",
        "i686": "i686",
        "x86_64": "x86-64",
    }
    build_cflags = d.getVar("BUILD_CFLAGS", True)
    build_arch = d.getVar("BUILD_ARCH", True)
    if '-march' not in build_cflags and build_arch in arch_args:
        d.setVar("BUILD_MARCH", "-march={0}".format(arch_args[build_arch]))
        d.appendVar("BUILD_CFLAGS", " ${BUILD_MARCH}")

        # This is needed to ensure that a change to the BUILD_ARCH won't cause
        # target signatures to change, which is needed to allow sstate reuse
        # for target recipes across 32/64 bit hosts.
        d.appendVarFlag("BUILD_CFLAGS", "vardepsexclude", "BUILD_MARCH")
}
add_build_march[eventmask] = "bb.event.ConfigParsed"
addhandler add_build_march
