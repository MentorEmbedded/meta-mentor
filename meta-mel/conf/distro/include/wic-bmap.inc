# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# If a wic image type is enabled, also enable wic.bmap
python add_wic_bmap () {
    image_fstypes = d.getVar('IMAGE_FSTYPES', True).split()
    if any(f == 'wic' or f.startswith('wic.') for f in image_fstypes):
        d.setVar('IMAGE_FSTYPES', " ".join (image_fstypes + ['wic.bmap']))
}
add_wic_bmap[eventmask] = "bb.event.ConfigParsed"
addhandler add_wic_bmap
