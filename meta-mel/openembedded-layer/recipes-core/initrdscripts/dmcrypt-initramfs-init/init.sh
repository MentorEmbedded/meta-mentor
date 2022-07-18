#!/bin/sh

# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

PATH=/sbin:/bin:/usr/sbin:/usr/bin
CONSOLE="/dev/console"

TARGET_ROOT_MOUNT="/target_rootfs"

# LUKS-enabled devices
TARGET_ROOTFS_NAME="rootfs"
TARGET_LOGFS_NAME="logfs"
TARGET_ROOTFS_DEVICE="/dev/mapper/${TARGET_ROOTFS_NAME}"

LOG_FILE="${TARGET_BOOT_MOUNT}/boot.log"

# log <error-level> <msg>
function log {
	if [ "$#" -ne "2" ]; then
		echo "${FUNCNAME} <error-level> <msg>"
	fi

	local level="$1";
	local msg="$2";

	date=`date`;

	if [ -n "${SYSTEMD_ENV}" ] && [ "${SYSTEMD_ENV}" -eq "1" ]; then
		echo -e "${level} ${msg}"
	else
		echo -e "# ${date} ${level} ${msg}"
	fi

	echo "# ${date} ${level} ${msg}" >> ${LOG_FILE}

	if [ "${level}" == "error" ]; then
		local frame=0
		local stacktrace="";

		while true; do
			stacktrace+=`caller $frame`
			if [ "$?" -ne 0 ]; then
				break
			fi

			_ret=$?
			stacktrace+=$'\n'
			((frame++));
		done

		stacktrace=`echo ${stacktrace} |cut -f1-2 -d' ' |tr ' ' ':'`

		echo "Stacktrace: "
		echo "${stacktrace}"
		echo "Stacktrace: " >> ${LOG_FILE}
		echo "${stacktrace}" >> ${LOG_FILE}
	fi;
}

udev_daemon() {
	OPTIONS="/sbin/udev/udevd /sbin/udevd /lib/udev/udevd /lib/systemd/systemd-udevd"

	for o in $OPTIONS; do
		if [ -x "$o" ]; then
			echo $o
			return 0
		fi
	done

	return 1
}

_UDEV_DAEMON=`udev_daemon`


early_setup() {
   	mkdir -p /proc
	mkdir -p /sys
	mount -t proc proc /proc
	mount -t sysfs sysfs /sys
	mount -n -o mode=0755 -t devtmpfs none /dev


	mkdir -p /run
	mkdir -p /var/run
	$_UDEV_DAEMON --daemon
	udevadm trigger --action=add
	udevadm settle --timeout=3
	return 0
}

read_args() {
	for arg in $CMDLINE; do
		optarg=`expr "x$arg" : 'x[^=]*=\(.*\)'`
		case $arg in
			LABEL=*)
				label=$optarg
			;;
			ROOT_PART=*)
				ROOT_PART=$optarg
			;;
		esac
	done
}

do_boot() {
	echo "Boot procedure ..."

	if [ -z "${ROOT_PART}" ]; then
		log "error" "ROOT_PART not set"
		return 1
	fi

	# rootfs
	sleep 4s
	echo -ne "\n\n Open Encrypted root filesystem...\n"
	cmd="cryptsetup -v open ${ROOT_PART} ${TARGET_ROOTFS_NAME}"
	output=`eval ${cmd}`
	ret=$?
	if [ ${ret} -ne 0 ]; then
		log "error" "failed to open LUKS device ${ROOT_PART} as ${TARGET_ROOTFS_NAME}"
		log "error" "${cmd} (${ret}): ${output}"
		return 1
	fi;

	# TODO check filesystems

	# Watches the udev event queue, and exits if all current events are handled
	udevadm settle --timeout=3
	killall "${_UDEV_DAEMON##*/}" 2>/dev/null

	cmd="mkdir -p ${TARGET_ROOT_MOUNT}"
	output=`eval ${cmd}`
	ret=$?
	if [ ${ret} -ne 0 ]; then
		log "error" "${cmd} (${ret}): ${output}"
		return 1
	fi;
	
	cmd="mount -t ext4 ${TARGET_ROOTFS_DEVICE} ${TARGET_ROOT_MOUNT}"
	output=`eval ${cmd}`
	ret=$?
	if [ ${ret} -ne 0 ]; then
		log "error" "${cmd} (${ret}): ${output}"
		return 1
	fi;

	cd ${TARGET_ROOT_MOUNT}
	exec switch_root ${TARGET_ROOT_MOUNT} /sbin/init $CMDLINE
}

do_console() {
	echo "Starting console ..."
	
	# get name of active terminal
	CONSOLE=`cat /sys/devices/virtual/tty/console/active | cut -d " " -f2`
	
	# run shell on active terminal
	setsid sh -c "exec sh </dev/$CONSOLE >/dev/$CONSOLE 2>&1"
}

# Main

early_setup
if [ "$?" -ne "0" ]; then
	log "error" "early_setup failed"
	do_console
fi;

if [ $# -ne 0 ]; then
	CMDLINE="$@"
else
	CMDLINE=`cat /proc/cmdline`
fi;

read_args
case $label in
	boot)
		do_boot
		if [ "$?" -ne "0" ]; then
			log "error" "boot failed, rebooting in 10 sec"
			sleep 10
			reboot -f
		fi;
		;;

	console)
		do_console
		;;
	*)
		echo "Unrecognized option ${label}"
		;;

esac
