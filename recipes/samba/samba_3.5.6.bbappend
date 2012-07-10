PR .= ".3"
EXTRA_OECONF += "\
	ac_cv_path_PYTHON=/not/exist \
	--disable-avahi \
	--without-acl-support \
"
