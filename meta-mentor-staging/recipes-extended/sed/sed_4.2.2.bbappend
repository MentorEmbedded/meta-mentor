# Remove hardcoded dependency upon locale-base-ru-ru in favor of
# a recommendation, as it isn't always available, depending on the value of
# GLIBC_GENERATE_LOCALES.
RDEPENDS_${PN}-ptest_remove = "locale-base-ru-ru"
RRECOMMENDS_${PN}-ptest += "locale-base-ru-ru"
