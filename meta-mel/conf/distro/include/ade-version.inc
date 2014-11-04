ADE_TIMESTAMP := "${@str(int(time.time()))}"
ADE_VERSION ?= "${@'${SDK_VERSION}'.replace('+snapshot', '')}.${ADE_TIMESTAMP}"

python ade_version_setup () {
    e.data.appendVar("BB_HASHCONFIG_WHITELIST", " ADE_TIMESTAMP")
}
ade_version_setup[eventmask] = "bb.event.ConfigParsed"
addhandler ade_version_setup
