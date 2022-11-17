# We use scancode utlity for extacting licence information.
# scancode itself is an OSS Utlitity.
# For more informaiton https://github.com/nexB/scancode-toolkit
# scancode is used from HOSTTOOLS.

SCANCODE_FORMAT ?= "html-app"
EXT = "${@'html' if d.getVar('SCANCODE_FORMAT', True) == 'html-app' else 'json'}"

do_scancode() {
	mkdir -p ${DEPLOY_DIR_IMAGE}/scancode
	if [ -d "${S}" ]; then
		scancode ${S} --format  ${SCANCODE_FORMAT} ${DEPLOY_DIR_IMAGE}/scancode/${PN}.${EXT}
	fi
}

addtask scancode after do_patch

do_scancode_oss() {
    echo "We are done running scancode"
}

do_scancode_oss[recrdeptask] = "do_scancode_oss do_scancode"
do_scancode_oss[nostamp] = "1"
addtask do_scancode_oss after do_scancode
