PARALLEL_MAKE = ""

# Kill the hardcoded rubygemsdir, letting it find it relative to its prefix
EXTRA_OECONF_remove = "--with-rubygemsdir=${datadir}/rubygems"

# Load files relative to the ruby binary's location
EXTRA_OECONF += "--enable-load-relative"
