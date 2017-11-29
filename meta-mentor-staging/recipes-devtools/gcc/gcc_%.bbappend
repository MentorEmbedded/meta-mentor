# Align TARGET_SYS and TARGET_PREFIX to avoid binary links which include both.
TARGET_SYS := "${@TARGET_PREFIX[:-1]}"
