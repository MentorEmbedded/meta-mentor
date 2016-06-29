# Older qemu don't support all the configure options which the current
# qemu.inc will pass.
python kill_unsupported_configs () {
    d.delVarFlag('PACKAGECONFIG', 'gtk+')
    d.delVarFlag('PACKAGECONFIG', 'glx')
}
kill_unsupported_configs[eventmask] = 'bb.event.RecipePreFinalise'
addhandler kill_unsupported_configs
