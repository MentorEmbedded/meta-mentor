# If a wic image type is enabled, also enable wic.bmap. We use an event
# handler here, as we can't reference IMAGE_FSTYPES from inline python in the
# same variable, and while we can reference WKS_FULL_PATH, then the value in
# the config metadata would be different than in image recipes. This wouldn't
# normally be a problem, but toaster is using the config metadata value.
python add_wic_bmap () {
    image_fstypes = d.getVar('IMAGE_FSTYPES', True).split()
    if any(f == 'wic' or f.startswith('wic.') for f in image_fstypes):
        d.setVar('IMAGE_FSTYPES', " ".join (image_fstypes + ['wic.bmap']))
}
add_wic_bmap[eventmask] = "bb.event.ConfigParsed"
addhandler add_wic_bmap
