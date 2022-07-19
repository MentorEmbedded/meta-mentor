# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

# For multilib variants not listed in SDK_MULTILIB_VARIANTS, remove
# SDK_DEFAULT_TARGET_PKGS from TOOLCHAIN_TARGET_TASK
#
# This allows us to control which multilibs get the default sdk target
# packages installed, by altering SDK_MULTILIB_VARIANTS to differ from
# MULTILIB_VARIANTS.

MULTILIB_VARIANTS ??= ""
SDK_MULTILIB_VARIANTS ??= "${MULTILIB_VARIANTS}"
SDK_DEFAULT_TARGET_PKGS ?= "packagegroup-core-standalone-sdk-target packagegroup-core-standalone-sdk-target-dbg"

SDK_MULTILIB_VARIANTS_REMOVE = "${@' '.join(set('${MULTILIB_VARIANTS}'.split()) - set('${SDK_MULTILIB_VARIANTS}'.split()))}"
SDK_TARGET_REMOVE = "${@' '.join(v + '-' + p for p in '${SDK_DEFAULT_TARGET_PKGS}'.split() for v in '${SDK_MULTILIB_VARIANTS_REMOVE}'.split())}"
TOOLCHAIN_TARGET_TASK:remove = "${SDK_TARGET_REMOVE}"
