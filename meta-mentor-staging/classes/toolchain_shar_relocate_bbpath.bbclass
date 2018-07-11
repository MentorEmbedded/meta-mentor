TOOLCHAIN_SHAR_RELOCATE = "${@bb.utils.which(d.getVar('BBPATH'), 'files/toolchain-shar-relocate.sh')}"

python create_shar_relocate () {
    creating_shar = 'create_shar' in [i.strip() for i in d.getVar('SDK_PACKAGING_FUNC').split(';')]
    if creating_shar and d.getVar('SDK_RELOCATE_AFTER_INSTALL') == '1':
        d.setVar('SDK_RELOCATE_AFTER_INSTALL', '0')
        bb.utils.copyfile(d.getVar('TOOLCHAIN_SHAR_RELOCATE'), os.path.join(d.getVar('T'), 'post_install_command')) 
}

do_populate_sdk[file-checksums] += "${TOOLCHAIN_SHAR_RELOCATE}:True"
SDK_PACKAGING_FUNC_prepend = "create_shar_relocate;"
