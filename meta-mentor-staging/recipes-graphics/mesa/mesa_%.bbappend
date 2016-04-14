# Don't provide functionality we've disabled
PROVIDES_remove = "\
    ${@bb.utils.contains('PACKAGECONFIG', 'egl', '', 'virtual/egl', d)} \
    ${@bb.utils.contains('PACKAGECONFIG', 'gles', '', 'virtual/libgles1 virtual/libgles2', d)} \
"
