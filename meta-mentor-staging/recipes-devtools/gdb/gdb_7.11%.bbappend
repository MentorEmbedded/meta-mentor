FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Fix-PR-gdb-20287-x32-and-gdb_static_assert-sizeof-na.patch \
            file://0001-Fix-PR-gdb-20413-x32-linux_ptrace_test_ret_to_nx-Can.patch file://0002-Fix-PR-server-20414-x32-gdbserver-always-crashes-inf.patch file://0003-Also-define-amd64_linux-funcs-for-x32.patch \
            "

