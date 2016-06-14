resolve_linked_file () {
    # The fetcher unpack method symlinks devmem2.c, so we can't patch it
    # unless we get a copy of the file
    if [ -h devmem2.c ]; then
        dest="$(readlink devmem2.c)"
        rm devmem2.c
        cp -f "$dest" devmem2.c
    fi
}
resolve_linked_file[dirs] = "${WORKDIR}"
do_unpack[postfuncs] += "resolve_linked_file"
