python add_kernel_imgtype_link () {
    if isinstance(e, bb.event.RecipePreFinalise) and oe.utils.inherits(e.data, 'kernel'):
        e.data.setVar('kernel_do_deploy_append', 'kernel_imgtype_link\n')
}
addhandler add_kernel_imgtype_link

kernel_imgtype_link () {
    ln -sf ${KERNEL_IMAGE_BASE_NAME}.bin ${KERNEL_IMAGETYPE}
}
