SUMMARY = "gdbserver binary path environment variable for the SDK"
DESCRIPTION = "${SUMMARY}. CodeBench will use this to know how to spawn gdbserver on the target."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SRC_URI = ""

inherit nativesdk

gdbserver_path = "${bindir}/gdbserver"

do_compile () {
    printf 'gdbserver_path=${gdbserver_path}\n' >gdbserver.sh
}

do_install () {
    install -d "${D}${SDKPATHNATIVE}/environment-setup.d"
    install -m 0644 -o root -g root gdbserver.sh "${D}${SDKPATHNATIVE}/environment-setup.d/"
}

FILES_${PN} += "${SDKPATHNATIVE}/environment-setup.d/*"
