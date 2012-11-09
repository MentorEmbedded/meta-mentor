PRINC := "${@int(PRINC) + 2}"

# We prefer rpcbind over portmap
RDEPENDS_packagegroup-base-nfs = "rpcbind"
