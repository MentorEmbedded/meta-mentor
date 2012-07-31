PRINC := "${@int(PRINC) + 1}"
RPROVIDES_${PN}_virtclass-native = "dbus-x11-native"
RPROVIDES_${PN}_virtclass-nativesdk = "dbus-x11-nativesdk"
