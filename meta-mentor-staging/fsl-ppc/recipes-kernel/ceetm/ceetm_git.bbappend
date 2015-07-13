do_compile_prepend(){
    oe_runmake CC='${CC}' lib
}

MAKE_TARGETS = "module"
