inherit image_types

python do_write_wks_template () {
    """Write out expanded template contents to WKS_FULL_PATH."""
    import re

    template_body = d.getVar('_WKS_TEMPLATE', True)

    # Remove any remnant variable references left behind by the expansion
    # due to undefined variables
    expand_var_regexp = re.compile(r"\${[^{}@\n\t :]+}")
    while True:
        new_body = re.sub(expand_var_regexp, '', template_body)
        if new_body == template_body:
            break
        else:
            template_body = new_body

    wks_file = d.getVar('WKS_FULL_PATH', True)
    with open(wks_file, 'w') as f:
        f.write(template_body)
}

WKS_FILE_CHECKSUM = "${@'${WKS_FULL_PATH}:%s' % os.path.exists('${WKS_FULL_PATH}') if '${USING_WIC}' else ''}"

python () {
    """Read in and set up wks file template for wic."""
    file_checksums = d.getVarFlag('do_image_wic', 'file-checksums', False)
    old_wks_checksum = "${@'${WKS_FULL_PATH}:%s' % os.path.exists('${WKS_FULL_PATH}') if '${USING_WIC}' else ''}"
    d.setVarFlag('do_image_wic', 'file-checksums', file_checksums.replace(old_wks_checksum, '${WKS_FILE_CHECKSUM}'))

    if d.getVar('USING_WIC', True):
        wks_file_u = d.getVar('WKS_FULL_PATH', False)
        wks_file = d.expand(wks_file_u)
        base, ext = os.path.splitext(wks_file)
        if ext == '.in' and os.path.exists(wks_file):
            wks_out_file = os.path.join(d.getVar('WORKDIR', True), os.path.basename(base))
            d.setVar('WKS_FULL_PATH', wks_out_file)
            d.setVar('WKS_TEMPLATE_PATH', wks_file_u)
            d.setVar('WKS_FILE_CHECKSUM', '${WKS_TEMPLATE_PATH}:True')

            try:
                with open(wks_file, 'r') as f:
                    body = f.read()
            except (IOError, OSError) as exc:
                pass
            else:
                # Previously, I used expandWithRefs to get the dependency list
                # and add it to WICVARS, but there's no point re-parsing the
                # file in process_wks_template as well, so just put it in
                # a variable and let the metadata deal with the deps.
                d.setVar('_WKS_TEMPLATE', body)
                bb.build.addtask('do_write_wks_template', 'do_image_wic', None, d)
}
