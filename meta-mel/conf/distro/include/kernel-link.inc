python add_kernel_imgtype_link () {
    if oe.utils.inherits(e.data, 'kernel'):
        e.data.setVar('kernel_do_deploy_append', 'kernel_imgtype_link\n')
}
add_kernel_imgtype_link[eventmask] = "bb.event.RecipePreFinalise"
addhandler add_kernel_imgtype_link

kernel_imgtype_link () {
    ln -sf ${KERNEL_IMAGE_BASE_NAME}.bin ${KERNEL_IMAGETYPE}
}
