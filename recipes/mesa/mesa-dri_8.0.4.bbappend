PR = "${INC_PR}.2"

PACKAGECONFIG_append_marzenh1 = " gles egl"
PACKAGECONFIG_append_mx6 = " gles egl"

PROVIDES_mx6 = "virtual/libgl virtual/libgles1 virtual/libgles2 virtual/egl"
