EARLY_EXPANDED_VARS ?= ""
EARLY_EXPANDED_VARS[type] = "list"

python expand_vars_eh() {
    if isinstance(e, bb.event.ConfigParsed):
        def expand_vars(d):
            for var in oe.data.typed_value('EARLY_EXPANDED_VARS', d):
                d.setVar(var, d.getVar(var, True))

        expand_vars(e.data)
}
addhandler expand_vars_eh
