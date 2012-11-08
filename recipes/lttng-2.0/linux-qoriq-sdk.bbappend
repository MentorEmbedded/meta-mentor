PR_append = "b"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append := "file://commit-4ff16c2_backport.patch \
		   file://0001-udp-add-tracepoints-for-queueing-skb-to-rcvbuf.patch \
		   file://0001-core-add-tracepoints-for-queueing-skb-to-rcvbuf.patch \
		   "

