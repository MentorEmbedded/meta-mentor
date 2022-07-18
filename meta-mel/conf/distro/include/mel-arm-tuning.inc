# Use common compatible tuning values.
#
# This avoids unnecessary toolchain component rebuilds and increases reuse and compatibility amongst
# compatible machines.
#
# Imported from https://github.com/96boards/meta-rpb/blob/master/conf/distro/include/arm-defaults.inc
# Imported from https://github.com/Angstrom-distribution/meta-angstrom/blob/master/conf/distro/include/arm-defaults.inc

def get_generic_tune(d):
    features = d.getVar('TUNE_FEATURES').split()
    if 'aarch64' in features:
        tune = 'armv8a'
        if 'crc' in features:
            tune += '-crc'
        if 'crypto' in features:
            tune += '-crypto'
    # cortexa* tune files only list 'arm' in features instead of 'armv7*'
    elif 'armv7a' in features or 'armv7ve' in features or ('arm' in features and 'neon' in features):
        tune = 'armv7athf'
        if 'bigendian' in features:
            tune += 'b'
        if 'neon' in features:
            tune += '-neon'
    else:
        tune = d.getVar('DEFAULTTUNE')
    return tune

DEFAULTTUNE:mel := "${@get_generic_tune(d)}"
