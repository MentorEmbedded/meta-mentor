EXTRA_OEMAKE += "'PERL_PATH=/usr/bin/env perl'"

# RUNTIME_PREFIX has multiple bugs at this time, as far as I can tell. Revert
# to the previous wrapper-based relocation mechanism
EXTRA_OEMAKE := "${@oe_filter_out('RUNTIME_PREFIX=1', EXTRA_OEMAKE, d)}"

REL_GIT_EXEC_PATH = "${@os.path.relpath(libexecdir, bindir)}/git-core"
REL_GIT_TEMPLATE_DIR = "${@os.path.relpath(datadir, bindir)}/git-core/templates"

do_install_append_class-native() {
	create_wrapper ${D}${bindir}/git \
		GIT_EXEC_PATH='`dirname $''realpath`'/${REL_GIT_EXEC_PATH} \
		GIT_TEMPLATE_DIR='`dirname $''realpath`'/${REL_GIT_TEMPLATE_DIR} \
}

do_install_append_class-nativesdk() {
	create_wrapper ${D}${bindir}/git \
		GIT_EXEC_PATH='`dirname $''realpath`'/${REL_GIT_EXEC_PATH} \
		GIT_TEMPLATE_DIR='`dirname $''realpath`'/${REL_GIT_TEMPLATE_DIR} \
}
