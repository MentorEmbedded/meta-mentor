VIRTUAL-RUNTIME_bluetooth-stack ?= "bluez4"
PACKAGECONFIG[bluetooth] = "--enable-bluetooth,--disable-bluetooth,virtual/libbluetooth,${VIRTUAL-RUNTIME_bluetooth-stack}"
DEPENDS_remove = "bluez4"
