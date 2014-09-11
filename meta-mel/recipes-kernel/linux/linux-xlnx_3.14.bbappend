FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " \
    file://xilinx_zynq_base_trd.cfg \
    file://openamp.cfg \
    file://0001-openamp-integrate-OpenAMP-support.patch \
"

# The latest kernel in meta-xilinx is missing critical graphic driver commits,
# we will base our work on the latest vendor kernel.
SRCREV = "c0292a5c3919cf777f9d21202e022c99ce255b8f"
