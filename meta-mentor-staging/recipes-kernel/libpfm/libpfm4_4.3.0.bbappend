do_configure () {
    sed -i 's#^SLDFLAGS=#SLDFLAGS=\$(LDFLAGS)\ #' lib/Makefile
}

