# Clear blacklist if we want to include mplayer
UPSTREAM_BLACKLIST_VALUE := "${@d.getVarFlag('PNBLACKLIST', 'mplayer2', False)}"
PNBLACKLIST[mplayer2] = "${@bb.utils.contains('INCLUDE_MPLAYER', 'yes', '', '${UPSTREAM_BLACKLIST_VALUE}', d)}"
