# Ensure that libvirt uses polkit rather than policykit, whether the host has
# pkcheck installed or not, and ensure the path is correct per our config.
CACHED_CONFIGUREVARS += "ac_cv_path_PKCHECK_PATH=${bindir}/pkcheck"
