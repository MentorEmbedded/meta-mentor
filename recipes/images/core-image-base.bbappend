# We want an ssh server in our base image
PRINC := "${@int(PRINC) + 1}"
IMAGE_FEATURES += "${SSHSERVER_IMAGE_FEATURES}"
