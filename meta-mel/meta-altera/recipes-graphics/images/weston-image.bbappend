# * winpr-makecert tool, installed with freerdp, is required for generating
#   TLS certificate/key couple needed by weston's rdp backend
# * Install connman for managing network connections.
IMAGE_INSTALL_append_cyclone5 = " freerdp connman"
