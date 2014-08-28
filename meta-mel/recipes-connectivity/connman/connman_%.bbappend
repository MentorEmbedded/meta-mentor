VIRTUAL-RUNTIME_bluetooth-stack ?= "bluez4"
PACKAGECONFIG[bluetooth] := "${@d.getVarFlag('PACKAGECONFIG', 'bluetooth').replace('bluez4', '${VIRTUAL-RUNTIME_bluetooth-stack}')}"
