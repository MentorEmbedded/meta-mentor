# The e2fsprogs recipe has the main package depending upon blkid and badblocks
# for compatibility, but we know we aren't bitten by that compatibility issue,
# so we drop that dependency.
RDEPENDS_e2fsprogs_mel = ""
