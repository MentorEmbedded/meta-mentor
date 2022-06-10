# Work around lack of support for environment-setup.d in CodeBench
SDK_PACKAGING_COMMAND:prepend:sdk-codebench-metadata = "merge_environment_setup_d; add_no_sysroot_suffix;"

merge_environment_setup_d() {
    for setup_d in "${SDK_OUTPUT}${SDKPATH}/sysroots/"*/environment-setup.d; do
        if [ -d "$setup_d" ]; then
            for script in "${SDK_OUTPUT}${SDKPATH}/environment-setup-"*; do
                find "$setup_d" -type f -print0 | xargs -0 cat >>"$script"
            done
            rm -rf "$setup_d"
        fi
    done
}

add_no_sysroot_suffix() {
    # Codebench expects the --no-sysroot-suffix entries to be in the main
    # variables, not the appended ones from external.sh
    for script in "${SDK_OUTPUT}${SDKPATH}/environment-setup-"*; do
        sed -i -e "/no-sysroot-suffix/d; /\(CC\|CXX\|CPP\|KCFLAGS\)/s/--sysroot=/--no-sysroot-suffix --sysroot=/g" "$script"
    done
}
