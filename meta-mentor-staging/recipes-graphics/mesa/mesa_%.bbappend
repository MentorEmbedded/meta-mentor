# Don't provide functionality we've disabled
PROVIDES_remove = "\
    ${@bb.utils.contains('PACKAGECONFIG', 'egl', '', 'virtual/egl', d)} \
    ${@bb.utils.contains('PACKAGECONFIG', 'gles', '', 'virtual/libgles1 virtual/libgles2', d)} \
"

# Adding GLES3 headers to libgles2-mesa-dev package
FILES_libgles2-mesa-dev += "${includedir}/GLES3"
