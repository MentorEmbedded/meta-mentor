# This material contains trade secrets or otherwise confidential information owned by Siemens Industry Software Inc.
# or its affiliates (collectively, "Siemens"), or its licensors. Access to and use of this information is strictly limited
# as set forth in the Customer's applicable agreements with Siemens.
# ---------------------------------------------------------------------------------------------------------------------
# Unpublished work. Copyright 2021 Siemens
# ---------------------------------------------------------------------------------------------------------------------

SUMMARY = "Relocate makefile fragments and environment-setup.d"
LICENSE = "MIT"
BASEDEPENDS = ""

S = "${WORKDIR}"

inherit nativesdk

do_compile () {
    echo '#!/bin/sh' >relocate.sh
    echo 'for i in $1/sysroots/*/environment-setup.mk $1/sysroots/*/environment-setup.d/*.sh $1/sysroots/*/environment-setup.d/*.mk; do if [ -e "$i" ]; then sed -i -e "s,@SDKPATH@,$1,g" "$i"; fi; done' >>relocate.sh
}

do_install () {
    install -d ${D}${SDKPATHNATIVE}/post-relocate-setup.d
    install -m 0755 relocate.sh ${D}${SDKPATHNATIVE}/post-relocate-setup.d/${BPN}.sh
}

FILES:${PN} += "${SDKPATHNATIVE}"
