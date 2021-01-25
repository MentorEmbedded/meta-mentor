python () {
    image_fstypes = d.getVar('IMAGE_FSTYPES', True).split()
    if any(f == 'wic' or f.startswith('wic.') for f in image_fstypes):
        d.setVar('IMAGE_FSTYPES', ' '.join (image_fstypes + ['wic.bmap']))
}
