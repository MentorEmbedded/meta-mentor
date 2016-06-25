#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

ROOT_MOUNT="/rootfs/"
ROOT_IMAGE="rootfs.img"
MOUNT="/bin/mount"
UMOUNT="/bin/umount"
ISOLINUX=""

# Copied from initramfs-framework. The core of this script probably should be
# turned into initramfs-framework modules to reduce duplication.
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
    mount -t devtmpfs none /dev

    # support modular kernel
    modprobe isofs 2> /dev/null

    mkdir -p /run
    mkdir -p /var/run

    $_UDEV_DAEMON --daemon
    udevadm trigger --action=add
}

read_args() {
    [ -z "$CMDLINE" ] && CMDLINE=`cat /proc/cmdline`
    for arg in $CMDLINE; do
        optarg=`expr "x$arg" : 'x[^=]*=\(.*\)'`
        case $arg in
            root=*)
                ROOT_DEVICE=$optarg ;;
            rootimage=*)
                ROOT_IMAGE=$optarg ;;
            rootfstype=*)
                modprobe $optarg 2> /dev/null ;;
            LABEL=*)
                label=$optarg ;;
            video=*)
                video_mode=$arg ;;
            vga=*)
                vga_mode=$arg ;;
            console=*)
                if [ -z "${console_params}" ]; then
                    console_params=$arg
                else
                    console_params="$console_params $arg"
                fi ;;
            debugshell*)
                if [ -z "$optarg" ]; then
                        shelltimeout=30
                else
                        shelltimeout=$optarg
                fi 
        esac
    done
}

boot_live_root() {
    # Watches the udev event queue, and exits if all current events are handled
    udevadm settle --timeout=3 --quiet
    killall "${_UDEV_DAEMON##*/}" 2>/dev/null

    # Move the mount points of some filesystems over to
    # the corresponding directories under the real root filesystem.
    for dir in `awk '/\/dev.* \/media/{print $2}' /proc/mounts`; do
        mkdir -p  ${ROOT_MOUNT}/$dir
        mount -n --move $dir ${ROOT_MOUNT}/$dir
    done
    mount -n --move /proc ${ROOT_MOUNT}/proc
    mount -n --move /sys ${ROOT_MOUNT}/sys
    mount -n --move /dev ${ROOT_MOUNT}/dev

    cd $ROOT_MOUNT

    # busybox switch_root supports -c option
    exec switch_root -c /dev/console $ROOT_MOUNT /sbin/init $CMDLINE ||
        fatal "Couldn't switch_root, dropping to shell"
}

fatal() {
    echo $1 >$CONSOLE
    echo >$CONSOLE
    exec sh
}

early_setup

[ -z "$CONSOLE" ] && CONSOLE="/dev/console"

read_args

echo "Waiting for removable media..."
C=0
while true
do
  for i in `ls /media 2>/dev/null`; do
      if [ -f /media/$i/$ROOT_IMAGE ] ; then
		found="yes"
		break
	  elif [ -f /media/$i/isolinux/$ROOT_IMAGE ]; then
		found="yes"
		ISOLINUX="isolinux"
		break	
      fi
  done
  if [ "$found" = "yes" ]; then
      break;
  fi
  # don't wait for more than $shelltimeout seconds, if it's set
  if [ -n "$shelltimeout" ]; then
      echo -n " " $(( $shelltimeout - $C ))
      if [ $C -ge $shelltimeout ]; then
           echo "..."
	   echo "Mounted filesystems"
           mount | grep media
           echo "Available block devices"
           ls /dev/sd*
           fatal "Cannot find $ROOT_IMAGE file in /media/* , dropping to a shell "
      fi
      C=$(( C + 1 ))
  fi
  sleep 1
done

# Try to mount the root image read-write and then boot it up.
# This function distinguishes between a read-only image and a read-write image.
# In the former case (typically an iso), it tries to make a union mount if possible.
# In the latter case, the root image could be mounted and then directly booted up.
mount_and_boot() {
    mkdir $ROOT_MOUNT
    mknod /dev/loop0 b 7 0 2>/dev/null

    if ! mount -o rw,loop,noatime,nodiratime /media/$i/$ISOLINUX/$ROOT_IMAGE $ROOT_MOUNT ; then
	fatal "Could not mount rootfs image"
    fi

    if touch $ROOT_MOUNT/bin 2>/dev/null; then
	# The root image is read-write, directly boot it up.
	boot_live_root
    fi

    # determine which unification filesystem to use
    union_fs_type=""
    if grep -q -w "overlayfs" /proc/filesystems; then
	union_fs_type="overlayfs"
    elif grep -q -w "aufs" /proc/filesystems; then
	union_fs_type="aufs"
    else
	union_fs_type=""
    fi

    # make a union mount if possible
    case $union_fs_type in
	"overlayfs")
	    mkdir -p /rootfs.ro /rootfs.rw
	    if ! mount -n --move $ROOT_MOUNT /rootfs.ro; then
		rm -rf /rootfs.ro /rootfs.rw
		fatal "Could not move rootfs mount point"
	    else
		mount -t tmpfs -o rw,noatime,mode=755 tmpfs /rootfs.rw
		mount -t overlayfs -o "lowerdir=/rootfs.ro,upperdir=/rootfs.rw" overlayfs $ROOT_MOUNT
		mkdir -p $ROOT_MOUNT/rootfs.ro $ROOT_MOUNT/rootfs.rw
		mount --move /rootfs.ro $ROOT_MOUNT/rootfs.ro
		mount --move /rootfs.rw $ROOT_MOUNT/rootfs.rw
	    fi
	    ;;
	"aufs")
	    mkdir -p /rootfs.ro /rootfs.rw
	    if ! mount -n --move $ROOT_MOUNT /rootfs.ro; then
		rm -rf /rootfs.ro /rootfs.rw
		fatal "Could not move rootfs mount point"
	    else
		mount -t tmpfs -o rw,noatime,mode=755 tmpfs /rootfs.rw
		mount -t aufs -o "dirs=/rootfs.rw=rw:/rootfs.ro=ro" aufs $ROOT_MOUNT
		mkdir -p $ROOT_MOUNT/rootfs.ro $ROOT_MOUNT/rootfs.rw
		mount --move /rootfs.ro $ROOT_MOUNT/rootfs.ro
		mount --move /rootfs.rw $ROOT_MOUNT/rootfs.rw
	    fi
	    ;;
	"")
	    mount -t tmpfs -o rw,noatime,mode=755 tmpfs $ROOT_MOUNT/media
	    ;;
    esac

    # boot the image
    boot_live_root
}

case $label in
    boot)
	mount_and_boot
	;;
    install|install-efi)
	if [ -f /media/$i/$ISOLINUX/$ROOT_IMAGE ] ; then
	    ./$label.sh $i/$ISOLINUX $ROOT_IMAGE $video_mode $vga_mode $console_params
	else
	    fatal "Could not find $label script"
	fi

	# If we're getting here, we failed...
	fatal "Installation image failed"
	;;
    *)
	# Not sure what boot label is provided.  Try to boot to avoid locking up.
	mount_and_boot
	;;
esac
