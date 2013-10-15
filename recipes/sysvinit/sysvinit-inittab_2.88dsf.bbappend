# sysvinit-inittab: Fix getting tty device name from SERIAL_CONSOLES entries

python () {
    do_install = d.getVar('do_install', False)
    d.setVar('do_install', do_install.replace("label=`echo ${i} | sed -e 's/^.*;tty//'`",
                                              "label=`echo ${i} | sed -e 's/^.*;tty//' -e 's/;.*//'`"))
}
