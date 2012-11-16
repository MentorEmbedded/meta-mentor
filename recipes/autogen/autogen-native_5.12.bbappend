PRINC := "${@int(PRINC) + 1}"
CACHED_CONFIGUREVARS += "ag_cv_test_guile_version=$guile_version"

do_configure_prepend () {
    guile_config_version=$(guile-config --version 2>&1)
    guile_version=$(echo $guile_config_version | sed 's/.*Guile version *//')
    if [ -z "$guile_version" ]; then
        guile_version=$(echo $guile_config_version | sed 's/.*Guile *//; 1q')
    fi
}
