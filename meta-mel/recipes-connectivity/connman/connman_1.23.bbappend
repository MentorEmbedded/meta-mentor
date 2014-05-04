PACKAGECONFIG[bluetooth] = "--enable-bluetooth, --disable-bluetooth,,${@'${VIRTUAL-RUNTIME_bluetooth-stack}' if 'mel' in '${OVERRIDES}'.split(':') else 'bluez4'}"
