# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

python do_archive_sdk_downloads () {
    pass
}
do_archive_sdk_downloads[dirs] = "${TOPDIR}"
do_archive_sdk_downloads[recrdeptask] = "do_archive_release_downloads_all do_archive_release_downloads"
do_archive_sdk_downloads[recideptask] = "do_${BB_DEFAULT_TASK} do_populate_sdk"
do_archive_sdk_downloads[nostamp] = "1"
addtask archive_sdk_downloads after do_archive_release_downloads_all
