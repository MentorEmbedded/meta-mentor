# Newer texinfo versions lose compatibility with make.texi, and lacking
# expertise with texinfo, we'll disable makeinfo use.
EXTRA_OEMAKE += "'MAKEINFO=true'"
