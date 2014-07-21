# We need openssl support for nativesdk-curl to ensure we can clone https
# repositories with nativesdk-git.
DEPENDS_append_class-nativesdk_mel = " nativesdk-openssl"
PACKAGECONFIG_append_class-nativesdk_mel = " ssl"
