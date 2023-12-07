# This material contains trade secrets or otherwise confidential information owned by Siemens Industry Software Inc.
# or its affiliates (collectively, "Siemens"), or its licensors. Access to and use of this information is strictly limited
# as set forth in the Customer's applicable agreements with Siemens.
# ---------------------------------------------------------------------------------------------------------------------
# Unpublished work. Copyright 2023 Siemens
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
                   file://0001-net-http-permit-request-with-invalid-Host-headers.patch \
"
