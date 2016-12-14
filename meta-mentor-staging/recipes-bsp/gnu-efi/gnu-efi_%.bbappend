python () {
    ccargs = d.getVar('TUNE_CCARGS', True).split()
    if '-mx32' in ccargs:
        # use x86_64 EFI ABI
        ccargs.remove('-mx32')
        ccargs.append('-m64')
        d.setVar('TUNE_CCARGS', ' '.join(ccargs))
}
