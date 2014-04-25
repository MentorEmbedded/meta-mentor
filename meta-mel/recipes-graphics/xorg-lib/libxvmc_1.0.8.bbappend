# Work around missing vardep bug in bitbake
do_install[vardeps] += "oe_runmake"
