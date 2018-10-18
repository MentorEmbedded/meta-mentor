LIC_FILES_CHKSUM_remove_mel-lite = "file://LICENSES;md5=e9a558e243b36d3209f380deb394b213"
SRCREV_mel-lite ?= "5a74abda201907cafbdabd1debf98890313ff71e"
SRC_URI_mel-lite = "git://sourceware.org/git/glibc.git;branch=release/2.28/master;name=glibc \
          file://0010-eglibc-run-libm-err-tab.pl-with-specific-dirs-in-S.patch \
          file://etc/ld.so.conf \
          file://generate-supported.mk"
