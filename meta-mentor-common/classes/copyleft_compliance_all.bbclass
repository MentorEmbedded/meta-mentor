# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

addtask prepare_copyleft_sources_all after do_prepare_copyleft_sources
do_prepare_copyleft_sources_all[recrdeptask] = 'do_prepare_copyleft_sources_all do_prepare_copyleft_sources'
do_prepare_copyleft_sources_all[nostamp] = "1"
python do_prepare_copyleft_sources_all() {
    pass
}
