python buildstats_summary () {
    if not isinstance(e, bb.event.BuildCompleted):
        return

    import os.path

    bn = get_bn(e)
    bsdir = os.path.join(e.data.getVar('BUILDSTATS_BASE', True), bn)
    if not os.path.exists(bsdir):
        return

    sstate, no_sstate = set(), set()
    for pf in os.listdir(bsdir):
        taskdir = os.path.join(bsdir, pf)
        if not os.path.isdir(taskdir):
            continue

        tasks = os.listdir(taskdir)
        if 'do_populate_sysroot_setscene' in tasks:
            sstate.add(pf)
        elif 'do_populate_sysroot' in tasks:
            no_sstate.add(pf)

    if not sstate and not no_sstate:
        return

    bb.note("Build completion summary:")
    bb.note("  From shared state: %d" % len(sstate))
    bb.note("  From scratch: %d" % len(no_sstate))
}
addhandler buildstats_summary
