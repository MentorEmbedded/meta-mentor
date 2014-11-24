#Don't use sysvinit based network configuration. We have connman for that purpose
SYSVINIT_SCRIPTS := "${@oe_filter_out('init-ifupdown', SYSVINIT_SCRIPTS, d)}"
