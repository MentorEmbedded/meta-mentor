import os
import tempfile
import time
import oe.terminal


class Gnome(oe.terminal.XTerminal):
    command = 'gnome-terminal -t "{title}" -x {command}'
    priority = 2

    def __init__(self, sh_cmd, title=None, env=None, d=None):
        # Recent versions of gnome-terminal does not support non-UTF8 charset:
        # https://bugzilla.gnome.org/show_bug.cgi?id=732127; as a workaround,
        # clearing the LC_ALL environment variable so it uses the locale.
        # Once fixed on the gnome-terminal project, this should be removed.
        if os.getenv('LC_ALL'): os.putenv('LC_ALL','')

        # We need to know when the command completes but gnome-terminal gives us no way 
        # to do this. We therefore write the pid to a file using a "phonehome" wrapper
        # script, then monitor the pid until it exits. Thanks gnome!
        pidfile = tempfile.NamedTemporaryFile(delete = False).name
        try:
            sh_cmd = bb.utils.which(d.getVar('PATH', True), "oe-gnome-terminal-phonehome") + " " + pidfile + " " + sh_cmd
            oe.terminal.XTerminal.__init__(self, sh_cmd, title, env, d)
            while os.stat(pidfile).st_size <= 0:
                continue
            with open(pidfile, "r") as f:
                pid = int(f.readline())
        finally:
            os.unlink(pidfile)

        while True:
            try:
                os.kill(pid, 0)
                time.sleep(0.1)
            except OSError:
               return

