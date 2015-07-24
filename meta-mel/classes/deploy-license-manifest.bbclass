ROOTFS_POSTPROCESS_COMMAND += "deploy_license_manifest;"
IMAGE_POSTPROCESS_COMMAND += "link_license_manifest;"

deploy_license_manifest () {
    if [ -e "${LICENSE_DIRECTORY}/${IMAGE_NAME}/license.manifest" ]; then
        cp ${LICENSE_DIRECTORY}/${IMAGE_NAME}/license.manifest ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.license_manifest
        sed -n '/PACKAGE NAME/{: start; /^ *$/b done; /LICENSE:/{s/: /: "/; s/$/"/;}; s/^.*://; H; n; b start; : done; x; s/^[\n ]*//; s/ *\n */,/g; p}' ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.license_manifest >${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.license_manifest.csv
    fi
}

link_license_manifest () {
    if [ -e "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.license_manifest" ]; then
        ln -sf ${IMAGE_NAME}.license_manifest ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.license_manifest
        ln -sf ${IMAGE_NAME}.license_manifest.csv ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.license_manifest.csv
    fi
}
