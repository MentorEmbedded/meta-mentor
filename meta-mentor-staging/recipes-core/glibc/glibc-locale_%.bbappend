# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# Work around long standing periodic host-user-contaminated QA failure by
# explicitly correcting the ownership.
#
# See `glibc-locale: Rewrite do_install using install utility instead of cp`
# on the oe-core mailing list for discussion. This should be dropped when
# a real fix is implemented.

do_prep_locale_tree:append () {
    chown -R root:root $treedir
}

# Explicitly disable host-user-contaminated to further work around the
# pseudo bug. With pseudo acting up, even if the ownership is correct,
# it may well think it is not, so just sidestep the issue until upstream
# fixes the root cause.
ERROR_QA:remove = "host-user-contaminated"
