license_create_manifest_append () {
    cp ${LICENSE_MANIFEST} ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.license_manifest
    rm -f ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.license_manifest
    ln -s ${IMAGE_NAME}.license_manifest ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.license_manifest

    # Deploy CSV form
    sed -n '/PACKAGE NAME/{: start; /^ *$/b done; /LICENSE:/{s/: /: "/; s/$/"/;}; s/^.*://; H; n; b start; : done; x; s/\n//g; s/^ //; s/ /,/g; p}' ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.license_manifest >${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.license_manifest.csv
    rm -f ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.license_manifest.csv
    ln -s ${IMAGE_NAME}.license_manifest.csv ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.license_manifest.csv
}
