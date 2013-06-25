license_create_manifest() {
	mkdir -p ${LICENSE_DIRECTORY}/${IMAGE_NAME}
	# Get list of installed packages
	list_installed_packages |sort > ${LICENSE_DIRECTORY}/${IMAGE_NAME}/package.manifest
	INSTALLED_PKGS=`cat ${LICENSE_DIRECTORY}/${IMAGE_NAME}/package.manifest`
	LICENSE_MANIFEST="${LICENSE_DIRECTORY}/${IMAGE_NAME}/license.manifest"
	# remove existing license.manifest file
	if [ -f ${LICENSE_MANIFEST} ]; then
		rm ${LICENSE_MANIFEST}
	fi
	touch ${LICENSE_MANIFEST}
	for pkg in ${INSTALLED_PKGS}; do
		# not the best way to do this but licenses are not arch dependant iirc
		filename=`ls ${TMPDIR}/pkgdata/*/runtime-reverse/${pkg}| head -1`
		pkged_pn="$(sed -n 's/^PN: //p' ${filename})"

		# check to see if the package name exists in the manifest. if so, bail.
		if grep -q "^PACKAGE NAME: ${pkg}" ${LICENSE_MANIFEST}; then
			continue
		fi

		pkged_pv="$(sed -n 's/^PV: //p' ${filename})"
		pkged_name="$(basename $(readlink ${filename}))"
		pkged_lic="$(sed -n "/^LICENSE_${pkged_name}: /{ s/^LICENSE_${pkged_name}: //; s/[|&()*]/ /g; s/  */ /g; p }" ${filename})"
		if [ -z ${pkged_lic} ]; then
			# fallback checking value of LICENSE
			pkged_lic="$(sed -n "/^LICENSE: /{ s/^LICENSE: //; s/[|&()*]/ /g; s/  */ /g; p }" ${filename})"
		fi

		echo "PACKAGE NAME:" ${pkg} >> ${LICENSE_MANIFEST}
		echo "PACKAGE VERSION:" ${pkged_pv} >> ${LICENSE_MANIFEST}
		echo "RECIPE NAME:" ${pkged_pn} >> ${LICENSE_MANIFEST}
		printf "LICENSE:" >> ${LICENSE_MANIFEST}
		for lic in ${pkged_lic}; do
			# to reference a license file trim trailing + symbol
			if ! [ -e "${LICENSE_DIRECTORY}/${pkged_pn}/generic_${lic%+}" ]; then
				bbwarn "The license listed ${lic} was not in the licenses collected for ${pkged_pn}"
			fi
                        printf " ${lic}" >> ${LICENSE_MANIFEST}
		done
		printf "\n\n" >> ${LICENSE_MANIFEST}
	done

	# Two options here:
	# - Just copy the manifest
	# - Copy the manifest and the license directories
	# With both options set we see a .5 M increase in core-image-minimal
	if [ -n "${COPY_LIC_MANIFEST}" ]; then
		mkdir -p ${IMAGE_ROOTFS}/usr/share/common-licenses/
		cp ${LICENSE_MANIFEST} ${IMAGE_ROOTFS}/usr/share/common-licenses/license.manifest
		if [ -n "${COPY_LIC_DIRS}" ]; then
			for pkg in ${INSTALLED_PKGS}; do
				mkdir -p ${IMAGE_ROOTFS}/usr/share/common-licenses/${pkg}
				for lic in `ls ${LICENSE_DIRECTORY}/${pkg}`; do
					# Really don't need to copy the generics as they're 
					# represented in the manifest and in the actual pkg licenses
					# Doing so would make your image quite a bit larger
					if [[ "${lic}" != "generic_"* ]]; then
						cp ${LICENSE_DIRECTORY}/${pkg}/${lic} ${IMAGE_ROOTFS}/usr/share/common-licenses/${pkg}/${lic}
					elif [[ "${lic}" == "generic_"* ]]; then
						if [ ! -f ${IMAGE_ROOTFS}/usr/share/common-licenses/${lic} ]; then
							cp ${LICENSE_DIRECTORY}/${pkg}/${lic} ${IMAGE_ROOTFS}/usr/share/common-licenses/
						fi
						ln -s ../${lic} ${IMAGE_ROOTFS}/usr/share/common-licenses/${pkg}/${lic}
					fi
				done
			done
		fi
	fi

}
