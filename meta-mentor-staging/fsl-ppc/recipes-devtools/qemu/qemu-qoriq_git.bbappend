# Older qemu don't support all the configure options which the current
# qemu.inc will pass.
unset PACKAGECONFIG[gtk+]
unset PACKAGECONFIG[glx]
