FILESEXTRAPATHS_append = ":${@os.path.dirname(bb.utils.which(BBPATH, 'files/encryptfs.cfg') or '')}"
SRC_URI_append = " file://encryptfs.cfg "
