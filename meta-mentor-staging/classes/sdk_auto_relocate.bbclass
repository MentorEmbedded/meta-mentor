# Automatically run our relocation scripts when necessary, when the user
# sources the environment setup script.
#
# If the sdk was installed with a method that can't run post-install scripts,
# then this will relocate the first time you source the script, otherwise
# it'll do so when the SDK install path changes (i.e. it was moved). To use
# this with the shar installer, you will want to pass -S when installing it,
# otherwise it will remove the relocation script this relies upon.

SDK_AUTO_RELOCATE_SOURCE ?= "1"
SDK_AUTO_RELOCATE_HOST_DEPENDS = "nativesdk-sdk-relocate"
TOOLCHAIN_HOST_TASK_append = " ${@d.getVar('SDK_AUTO_RELOCATE_HOST_DEPENDS') if bb.utils.to_boolean(d.getVar('SDK_AUTO_RELOCATE_SOURCE')) else ''}"

# Ensure that the shar installer writes .installpath, so we don't relocate the
# first time the user sources the environment setup script in that case.
SDK_POST_INSTALL_COMMAND_append = 'echo "${env_setup_script%/*}" >"${env_setup_script%/*}/.installpath";'
