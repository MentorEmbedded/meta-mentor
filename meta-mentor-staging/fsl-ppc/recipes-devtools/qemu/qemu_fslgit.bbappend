# Older qemu doesn't have this configure option
python kill_vte () {
    cfg = e.data.getVarFlag('PACKAGECONFIG', 'gtk+')
    cfg = cfg.replace('--disable-vte', '').replace('--enable-vte', '').replace(' libvte', '')
    e.data.setVarFlag('PACKAGECONFIG', 'gtk+', cfg)
}
kill_vte[eventmask] = 'bb.event.RecipePreFinalise'
addhandler kill_vte
