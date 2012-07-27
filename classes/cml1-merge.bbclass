python do_merge_configs(){
    def append_config(confmap):
            """
            Append configuration variables in .config from confmap
            """
            path = "%s/%s" % (bb.data.getVar('S', d, 1), ".config")

            # make sed delete command to remove changed variables in .config
            cmd = "sed -i "

            for k in confmap:
                cmd += "-e /%s/d " % k

            cmd += path

            os.system(cmd)

            for k, v in confmap.items():
                cmd = "%s" % k

                if v == " is not set":
                    cmd = "\# %s%s" % (cmd, v)
                else:

                    if v[0] == "'" and v[len(v)-1] == "'":
                        # value is a single quoted string
                        cmd = "%s=\\\'%s\\\'" % (cmd, v)
                    elif v[0] == "\"" and v[len(v)-1] == "\"":
                        # value is a double quoted string
                        cmd = "%s=\\\"%s\\\"" % (cmd, v)
                    else:
                        # value has no quotes
                        cmd = "%s=%s" % (cmd, v)

                # make the echo command to append config lines in .config
                cmd = "echo %s >> %s" % (cmd, path)

                os.system(cmd)


    import os
    import re

    confmap = dict()

    defconfig_list = bb.data.getVar('LINUX_ADDL_CFG', d, 1)

    if defconfig_list:
        exp_cfg = re.compile("CONFIG_(.*)")

        dlist = list()

        for i in defconfig_list.split():
            dlist.insert(0, i)

        for cfg in dlist:

            s = cfg
            path = "%s/%s" % (bb.data.getVar('WORKDIR', d, 1), s)

            f = open(path, 'r')
            line = f.readline()


            # make a dictionary of config (variables, value), override values while reading defconfigs
            while line:
                c = exp_cfg.search(line)

                if c:
                    str = c.group(0)

                    m1 = re.compile("(CONFIG_(.*))=(.*)")
                    m2 = re.compile("(CONFIG_(.*)) (is not set)")

                    # match config variables that are set to some value
                    set = m1.match(str)

                    if set:
                        val = set.group(3)
                        if confmap.has_key(set.group(1)):
                            if confmap[set.group(1)] == "y" and val == "m":
                                bb.note("%s value initially set to y is being overrided by m, keeping y" % set.group(1))
                                val = "y"
                        confmap[set.group(1)] = val
                    else:
                        # match config variables that are not set
                        unset = m2.match(str)
                        if unset:
                            confmap[unset.group(1)] = " is not set"

                line = f.readline()
            f.close()


    if confmap:
        # append the dictionary to .config
        append_config(confmap)
}

addtask merge_configs before do_refresh_config after do_configure

do_refresh_config(){
    yes '' | oe_runmake oldconfig
}

addtask refresh_config before do_qa_configure after do_merge_configs

python () {
    deps = d.getVarFlag('do_create_src_archive', 'deps') or []
    deps.append('do_refresh_config')
    d.setVarFlag('do_create_src_archive', 'deps', deps)
}
