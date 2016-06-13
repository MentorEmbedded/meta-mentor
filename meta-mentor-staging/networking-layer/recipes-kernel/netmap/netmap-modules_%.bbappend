# Add fallback to avoid breakage when passing None into bb.utils.vercmp_string
python () {
    if not d.getVar('KERNEL_VERSION', True):
        d.setVar('KERNEL_VERSION', '0.0')
}
