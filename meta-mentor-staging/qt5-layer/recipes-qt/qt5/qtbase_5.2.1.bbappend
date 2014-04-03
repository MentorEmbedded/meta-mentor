# Add missing libxi to DEPENDS for xinput packageconfigs
PACKAGECONFIG[xinput] = "-xinput,-no-xinput,libxi"
PACKAGECONFIG[xinput2] = "-xinput2,-no-xinput2,libxi"
