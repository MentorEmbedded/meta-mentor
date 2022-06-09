CB_MBS_OPTIONS ?= ""
CB_MBS_OPTIONS_FEATURES_MAP ?= ""
CB_MBS_OPTIONS_FLAGS_MAP ?= ""
CB_MBS_OPTIONS_FLAGS_VALUE_MAP ?= ""

CB_MBS_OPTIONS_CC_FLAGS_MAP ?= ""
CB_MBS_OPTIONS_CC_FLAGS_MAP[-g] = "compiler*option.debugging.level=debugging.level.default"
CB_MBS_OPTIONS_CC_FLAGS_MAP[-g0] = "compiler*option.debugging.level=debugging.level.none"
CB_MBS_OPTIONS_CC_FLAGS_MAP[-g1] = "compiler*option.debugging.level=debugging.level.minimal"
CB_MBS_OPTIONS_CC_FLAGS_MAP[-g3] = "compiler*option.debugging.level=debugging.level.max"
CB_MBS_OPTIONS_CC_FLAGS_MAP[-O0] = "compiler*option.optimization.level=optimization.level.none"
CB_MBS_OPTIONS_CC_FLAGS_MAP[-O1] = "compiler*option.optimization.level=optimization.level.optimize"
CB_MBS_OPTIONS_CC_FLAGS_MAP[-O2] = "compiler*option.optimization.level=optimization.level.more"
CB_MBS_OPTIONS_CC_FLAGS_MAP[-O3] = "compiler*option.optimization.level=optimization.level.most"
CB_MBS_OPTIONS_CC_FLAGS_MAP[-Os] = "compiler*option.optimization.level=optimization.level.size"
CB_MBS_OPTIONS_CC_FLAGS_MAP[-Og] = "compiler*option.optimization.level=optimization.level.debug"

CB_MBS_IGNORED_EXTRA_FLAGS ?= ""
CB_MBS_IGNORED_EXTRA_FLAGS += "${@'-mcpu=* -march=* -mtune=*' if d.getVarFlag('CB_MBS_OPTIONS', 'general.cpu', expand=True) else ''}"
CB_MBS_IGNORED_EXTRA_FLAGS += "${@'-mfpu=*' if d.getVarFlag('CB_MBS_OPTIONS', 'general.fpu', expand=True) else ''}"
CB_MBS_IGNORED_EXTRA_FLAGS[doc] = "Arguments we don't want to include in the extra options, as they're already handled elsewhere."

CB_MBS_IGNORED_FLAGS ?= ""
CB_MBS_IGNORED_FLAGS[doc] = "General flag arguments we don't want to include."

def get_cb_options(d):
    """Set default CodeBench metadata values based upon BitBake build flags."""
    import shlex
    import subprocess
    from fnmatch import fnmatchcase

    options = d.getVarFlags('CB_MBS_OPTIONS') or {}

    l = d.createCopy()
    l.finalize()
    l.setVar('DEBUG_PREFIX_MAP', '')
    l.setVar('STAGING_DIR_TARGET', '$SDKTARGETSYSROOT')

    features = d.getVar('TUNE_FEATURES').split()
    for feature, settings in (d.getVarFlags('CB_MBS_OPTIONS_FEATURES_MAP') or {}).items():
        if feature.startswith('-'):
            enabled = feature[1:] not in features
        else:
            enabled = feature in features
        if enabled:
            for setting in settings.split():
                skey, svalue = setting.split('=', 1)
                if setting and not options.get(skey):
                    options[skey] = svalue

    cflags = shlex.split(l.getVar('TARGET_CFLAGS', True))
    cxxflags = shlex.split(l.getVar('TARGET_CXXFLAGS', True))
    ldflags = shlex.split(l.getVar('TARGET_LDFLAGS', True))

    ccargs = shlex.split(l.getVar('TARGET_CC_ARCH', True))
    cflags.extend(ccargs)
    cxxflags.extend(ccargs)
    ldflags.extend(ccargs)

    ignored = d.getVar('CB_MBS_IGNORED_FLAGS', True).split()
    cflags = [a for a in cflags if not any(fnmatchcase(a, p) for p in ignored)]
    cxxflags = [a for a in cxxflags if not any(fnmatchcase(a, p) for p in ignored)]
    ldflags = [a for a in ldflags if not any(fnmatchcase(a, p) for p in ignored)]

    check_cflags, check_cxxflags = list(cflags), list(cxxflags)
    for flag, settings in (d.getVarFlags('CB_MBS_OPTIONS_FLAGS_MAP') or {}).items():
        for setting in settings.split():
            skey, svalue = setting.split('=', 1)
            if flag in check_cflags:
                if flag in cflags:
                    cflags.remove(flag)
                if setting and not options.get(skey):
                    options[skey] = svalue

            if flag in check_cxxflags:
                if flag in cxxflags:
                    cxxflags.remove(flag)
                if setting and not options.get(skey):
                    options[skey] = svalue

    for flag, settings in (d.getVarFlags('CB_MBS_OPTIONS_FLAGS_VALUE_MAP') or {}).items():
        for setting in settings.split():
            skey, svalue = setting.split('=', 1)
            for check_flag in check_cflags:
                if check_flag.startswith(flag + '='):
                    _, check_value = check_flag.split('=', 1)
                    if check_flag in cflags:
                        cflags.remove(check_flag)
                    if setting and not options.get(skey):
                        options[skey] = svalue + check_value

            for check_flag in check_cxxflags:
                if check_flag.startswith(flag + '='):
                    _, check_value = check_flag.split('=', 1)
                    if check_flag in cxxflags:
                        cxxflags.remove(check_flag)
                    if setting and not options.get(skey):
                        options[skey] = svalue + check_value

    for flag, settings in (d.getVarFlags('CB_MBS_OPTIONS_CC_FLAGS_MAP') or {}).items():
        for setting in settings.split():
            if flag in check_cflags:
                if flag in cflags:
                    cflags.remove(flag)
                if setting:
                    skey, svalue = setting.split('=', 1)
                    skey = 'gnu.c.' + skey
                    svalue = 'gnu.c.' + svalue
                    if not options.get(skey):
                        options[skey] = svalue

            if flag in check_cxxflags:
                if flag in cxxflags:
                    cxxflags.remove(flag)
                if setting:
                    skey, svalue = setting.split('=', 1)
                    skey = 'gnu.cpp.' + skey
                    svalue = 'gnu.cpp.compiler.' + svalue
                    if not options.get(skey):
                        options[skey] = svalue

    ignored = d.getVar('CB_MBS_IGNORED_EXTRA_FLAGS', True).split()
    cflags = [a for a in cflags if not any(fnmatchcase(a, p) for p in ignored)]
    cxxflags = [a for a in cxxflags if not any(fnmatchcase(a, p) for p in ignored)]
    ldflags = [a for a in ldflags if not any(fnmatchcase(a, p) for p in ignored)]

    if cflags:
        options['gnu.c.compiler*option.misc.other'] = subprocess.list2cmdline(cflags)
    if cxxflags:
        options['gnu.cpp.compiler*option.other.other'] = subprocess.list2cmdline(cxxflags)
    if ldflags:
        options['gnu.c.link*option.ldflags'] = subprocess.list2cmdline(ldflags)
        options['gnu.cpp.link*option.flags'] = subprocess.list2cmdline(ldflags)

    for option, value in list(options.items()):
        value = d.expand(value)
        if not value:
            del options[option]
        else:
            # Force immediate expansion, so we use target overrides regardless
            # of the context in which the flags are used
            options[option] = value

    return options

def cb_get_options(d, flags=None):
    options = cb_get_options_from_metadata(d)
    return cb_set_options_from_flags(d, options, flags)

def cb_mbs_flag_vars(d):
    import shlex
    import subprocess
    from fnmatch import fnmatchcase

    l = d.createCopy()
    l.finalize()
    l.setVar('DEBUG_PREFIX_MAP', '')
    l.setVar('STAGING_DIR_TARGET', '$SDKTARGETSYSROOT')

    features = d.getVar('TUNE_FEATURES').split()
    for feature, settings in (d.getVarFlags('CB_MBS_OPTIONS_FEATURES_MAP') or {}).items():
        if feature.startswith('-'):
            enabled = feature[1:] not in features
        else:
            enabled = feature in features
        if enabled:
            for setting in settings.split():
                skey, svalue = setting.split('=', 1)
                if setting and not options.get(skey):
                    options[skey] = svalue

    cflags = shlex.split(l.getVar('TARGET_CFLAGS', True))
    cxxflags = shlex.split(l.getVar('TARGET_CXXFLAGS', True))
    ldflags = shlex.split(l.getVar('TARGET_LDFLAGS', True))

    ccargs = shlex.split(l.getVar('TARGET_CC_ARCH', True))
    cflags.extend(ccargs)
    cxxflags.extend(ccargs)
    ldflags.extend(ccargs)

    ignored = d.getVar('CB_MBS_IGNORED_FLAGS', True).split()
    cflags = [a for a in cflags if not any(fnmatchcase(a, p) for p in ignored)]
    cxxflags = [a for a in cxxflags if not any(fnmatchcase(a, p) for p in ignored)]
    ldflags = [a for a in ldflags if not any(fnmatchcase(a, p) for p in ignored)]

    check_cflags, check_cxxflags = list(cflags), list(cxxflags)
    for flag, settings in (d.getVarFlags('CB_MBS_OPTIONS_FLAGS_MAP') or {}).items():
        for setting in settings.split():
            skey, svalue = setting.split('=', 1)
            if flag in check_cflags:
                if flag in cflags:
                    cflags.remove(flag)
                if setting and not options.get(skey):
                    options[skey] = svalue

            if flag in check_cxxflags:
                if flag in cxxflags:
                    cxxflags.remove(flag)
                if setting and not options.get(skey):
                    options[skey] = svalue

    for flag, settings in (d.getVarFlags('CB_MBS_OPTIONS_FLAGS_VALUE_MAP') or {}).items():
        for setting in settings.split():
            skey, svalue = setting.split('=', 1)
            for check_flag in check_cflags:
                if check_flag.startswith(flag + '='):
                    _, check_value = check_flag.split('=', 1)
                    if check_flag in cflags:
                        cflags.remove(check_flag)
                    if setting and not options.get(skey):
                        options[skey] = svalue + check_value

            for check_flag in check_cxxflags:
                if check_flag.startswith(flag + '='):
                    _, check_value = check_flag.split('=', 1)
                    if check_flag in cxxflags:
                        cxxflags.remove(check_flag)
                    if setting and not options.get(skey):
                        options[skey] = svalue + check_value

    for flag, settings in (d.getVarFlags('CB_MBS_OPTIONS_CC_FLAGS_MAP') or {}).items():
        for setting in settings.split():
            if flag in check_cflags:
                if flag in cflags:
                    cflags.remove(flag)
                if setting:
                    skey, svalue = setting.split('=', 1)
                    skey = 'gnu.c.' + skey
                    svalue = 'gnu.c.' + svalue
                    if not options.get(skey):
                        options[skey] = svalue

            if flag in check_cxxflags:
                if flag in cxxflags:
                    cxxflags.remove(flag)
                if setting:
                    skey, svalue = setting.split('=', 1)
                    skey = 'gnu.cpp.' + skey
                    svalue = 'gnu.cpp.compiler.' + svalue
                    if not options.get(skey):
                        options[skey] = svalue

    ignored = d.getVar('CB_MBS_IGNORED_EXTRA_FLAGS', True).split()
    cflags = [a for a in cflags if not any(fnmatchcase(a, p) for p in ignored)]
    cxxflags = [a for a in cxxflags if not any(fnmatchcase(a, p) for p in ignored)]
    ldflags = [a for a in ldflags if not any(fnmatchcase(a, p) for p in ignored)]

    if cflags:
        options['gnu.c.compiler*option.misc.other'] = subprocess.list2cmdline(cflags)
    if cxxflags:
        options['gnu.cpp.compiler*option.other.other'] = subprocess.list2cmdline(cxxflags)
    if ldflags:
        options['gnu.c.link*option.ldflags'] = subprocess.list2cmdline(ldflags)
        options['gnu.cpp.link*option.flags'] = subprocess.list2cmdline(ldflags)

    for option, value in list(options.items()):
        value = d.expand(value)
        if not value:
            del options[option]
        else:
            # Force immediate expansion, so we use target overrides regardless
            # of the context in which the flags are used
            options[option] = value

    return options
