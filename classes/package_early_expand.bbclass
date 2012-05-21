# Force early expansion of some problematic package-specific variables to
# avoid recursions (e.g. SUMMARY, DESCRIPTION)

EARLY_EXPANDED_PACKAGE_VARS ?= "SUMMARY DESCRIPTION"
EARLY_EXPANDED_PACKAGE_VARS[type] = "list"

PACKAGES[type] = "list"

python early_expand_vars() {
    for pkg in oe.data.typed_value('PACKAGES', d):
        for field in oe.data.typed_value('EARLY_EXPANDED_PACKAGE_VARS', d):
            varname = '%s_%s' % (field, pkg)
            value = d.getVar(varname, True)
            if value:
                d.setVar(varname, value)
}

python do_package_write_ipk () {
    bb.build.exec_func("read_subpackage_metadata", d)
    bb.build.exec_func("early_expand_vars", d)
    bb.build.exec_func("do_package_ipk", d)
}
