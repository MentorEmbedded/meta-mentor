# Link fails due to memory exhaustion, so disable debug info to reduce the
# memory footprint
DEBUG_FLAGS_remove = "-g"

# webkitgtk doesn't inherit pythonnative due to gobject-introspection pulling
# in python3-native, so the dep is missing
DEPENDS += "python-native"
