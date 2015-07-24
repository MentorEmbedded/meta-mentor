ROOTFS_POSTPROCESS_COMMAND += "deploy_license_manifest;"

deploy_license_manifest () {
    if [ -e "${LICENSE_DIRECTORY}/${IMAGE_NAME}/license.manifest" ]; then
        cp ${LICENSE_DIRECTORY}/${IMAGE_NAME}/license.manifest ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.license_manifest
        rm -f ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.license_manifest
        ln -s ${IMAGE_NAME}.license_manifest ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.license_manifest

        # Deploy CSV form
        sed -n '/PACKAGE NAME/{: start; /^ *$/b done; /LICENSE:/{s/: /: "/; s/$/"/;}; s/^.*://; H; n; b start; : done; x; s/\n//g; s/^ //; s/ /,/g; p}' ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.license_manifest >${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.license_manifest.csv
        rm -f ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.license_manifest.csv
        ln -s ${IMAGE_NAME}.license_manifest.csv ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.license_manifest.csv
    fi
}
