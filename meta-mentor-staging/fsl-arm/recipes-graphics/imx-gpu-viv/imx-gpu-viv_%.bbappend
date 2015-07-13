do_install[postfuncs] += "fixup_perms"
fixup_perms () {
    chown -R root:root "${D}"
}
