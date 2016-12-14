# thin-provisioning-tools are gplv3. if that's incompatible, we don't want to
# enable the packageconfig, otherwise the rdepend on it will fail the build
REMOVE_THIN = "${@incompatible_license_contains('GPL-3.0', 'thin-provisioning-tools', '', d)}"
PACKAGECONFIG_remove_mel = "${REMOVE_THIN}"
