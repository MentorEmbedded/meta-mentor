# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

SDK_MULTILIB_VARIANTS ?= "${MULTILIB_VARIANTS}"
python set_multilib_variants () {
    variants = d.getVar('SDK_MULTILIB_VARIANTS', True)
    if variants:
        d.setVar('MULTILIB_VARIANTS', variants)
}
do_generate_content[prefuncs] += "set_multilib_variants"
