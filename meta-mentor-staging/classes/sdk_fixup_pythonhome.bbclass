toolchain_create_sdk_env_script_append () {
    sed -i -e "/PYTHONHOME/d" "$script"
}
