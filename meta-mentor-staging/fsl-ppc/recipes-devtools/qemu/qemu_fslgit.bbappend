# Older qemu don't support all the configure options which the current
# qemu.inc will pass.
python kill_unsupported_configs () {
    e.data.delVarFlag('PACKAGECONFIG', 'gtk+')
    e.data.delVarFlag('PACKAGECONFIG', 'glx')
}
kill_unsupported_configs[eventmask] = 'bb.event.RecipePreFinalise'
addhandler kill_unsupported_configs
