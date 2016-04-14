# Don't provide functionality we've disabled
PROVIDES_remove = "\
    ${@bb.utils.contains('PACKAGECONFIG', 'egl', '', 'virtual/egl', d)} \
    ${@bb.utils.contains('PACKAGECONFIG', 'gles', '', 'virtual/libgles1 virtual/libgles2', d)} \
"

# gbm requires dri, so disable it when dri is disabled
PACKAGECONFIG[dri] = "--enable-dri --with-dri-drivers=${DRIDRIVERS} --enable-gbm, --disable-dri --disable-gbm, dri2proto libdrm"
