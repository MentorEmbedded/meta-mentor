# This isn't an ideal fix, but not everything is obeying the 'LINK' variable,
# and the qt3 build isn't using a qmake.conf that obeys the OE_QMAKE_
# variables. Rather than substantially reworking the qt3 build at this time,
# just hack it. We'll eventually bump LSB support and drop qt3 anyway.
CXX += "${LDFLAGS}"
