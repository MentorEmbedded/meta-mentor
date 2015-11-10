FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append = " file://0010-sharedtex_mt-fix-rendering-thread-hang.patch \
				   file://0001-drop-demos-dependant-on-obsolete-MESA_screen_surface.patch"
