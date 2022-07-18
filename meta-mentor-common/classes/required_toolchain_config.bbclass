# Sanity test for allowed toolchain configurations
#
# Must be explicitly enabled both by configuring these variables and
# adding 'disallowed-tuning' to your WARN_QA or ERROR_QA.
ALLOWED_TUNING ?= "${DEFAULTTUNE}"
DISALLOWED_TUNING ?= ""

python required_tuning () {
    def handle_error(error_class, error_msg, d):
        if error_class in (d.getVar("ERROR_QA") or "").split():
            bb.fatal("%s [%s]" % (error_msg, error_class))
        elif error_class in (d.getVar("WARN_QA") or "").split():
            bb.warn("%s [%s]" % (error_msg, error_class))
        else:
            bb.note("%s [%s]" % (error_msg, error_class))
        return True

    allowed = d.getVar('ALLOWED_TUNING')
    disallowed = d.getVar('DISALLOWED_TUNING')
    tuning = d.getVar('TUNE_PKGARCH')
    if tuning in disallowed.split():
        handle_error("disallowed-tuning", "TUNE_PKGARCH %s is disallowed by DISALLOWED_TUNING (%s)" % (tuning, disallowed), d)
    elif allowed and tuning not in allowed:
        handle_error("disallowed-tuning", "TUNE_PKGARCH %s is not allowed by ALLOWED_TUNING (%s)" % (tuning, allowed), d)
}
required_tuning[eventmask] = 'bb.event.SanityCheck'
addhandler required_tuning
