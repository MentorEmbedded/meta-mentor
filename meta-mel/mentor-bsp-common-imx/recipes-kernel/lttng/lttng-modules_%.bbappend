# This material contains trade secrets or otherwise confidential information owned by Siemens Industry Software Inc.
# or its affiliates (collectively, "Siemens"), or its licensors. Access to and use of this information is strictly limited
# as set forth in the Customer's applicable agreements with Siemens.
# ---------------------------------------------------------------------------------------------------------------------
# Unpublished work. Copyright 2022 Siemens
# ---------------------------------------------------------------------------------------------------------------------

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
 
SRC_URI_append = "\
		    file://0001-fix-random-tracepoints-removed-in-stable-kernels.patch \
		    file://0001-fix-block-remove-the-request-queue-to-argument-request-based.patch \
		    file://0002-fix-adjust-range-v5-10-137-in-block-probe.patch \
"
