# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

ROOTFS_POSTPROCESS_COMMAND += "deploy_license_manifest;"
IMAGE_POSTPROCESS_COMMAND += "link_license_manifest;"

deploy_license_manifest () {
    if [ -e "${LICENSE_DIRECTORY}/${IMAGE_NAME}/license.manifest" ]; then
        cp ${LICENSE_DIRECTORY}/${IMAGE_NAME}/license.manifest ${IMGDEPLOYDIR}/${IMAGE_NAME}.license_manifest
        sed -n '/PACKAGE NAME/{: start; /^ *$/b done; /LICENSE:/{s/: /: "/; s/$/"/;}; s/^.*://; H; n; b start; : done; x; s/^[\n ]*//; s/ *\n */,/g; p}' ${IMGDEPLOYDIR}/${IMAGE_NAME}.license_manifest >${IMGDEPLOYDIR}/${IMAGE_NAME}.license_manifest.csv
    fi
}

link_license_manifest () {
    if [ -e "${IMGDEPLOYDIR}/${IMAGE_NAME}.license_manifest" ]; then
        ln -sf ${IMAGE_NAME}.license_manifest ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.license_manifest
        ln -sf ${IMAGE_NAME}.license_manifest.csv ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.license_manifest.csv
    fi
}
