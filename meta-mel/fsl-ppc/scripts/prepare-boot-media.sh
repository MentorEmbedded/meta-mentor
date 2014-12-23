#! /bin/sh
# Script to create SD card or bootable USB for Freescale p1/p2 series targets.
#
# Author: Brijesh Singh, Texas Instruments Inc.
#       : Adapted for dra7xx-evm by Nikhil Devshatwar, Texas Instruments Inc.
#       : Adapted for FSL p1/p2 by Fahad Usman, Mentor Graphics Inc.
#
# Licensed under terms of GPLv2
#

VERSION="0.1"

: ${MACHINE:="p1010rdb"}
: ${KERNEL_DEVICETREE:="uImage-p1010rdb-pa.dtb"}
: ${sdkdir:="`pwd`/tmp/deploy/images/${MACHINE}"}

execute ()
{
    $* >/dev/null
    if [ $? -ne 0 ]; then
        echo
        echo "ERROR: executing $*"
        echo
        exit 1
    fi
}

version ()
{
  echo
  echo "`basename $1` version $VERSION"
  echo "Script to create bootable SD card or USB drive for Freescale p1/p2 series targets"
  echo

  exit 0
}

usage ()
{
  echo "
Usage: `basename $1` <options> [ files for install partition ]

Mandatory options:
  --device              SD/USB block device node (for example '/dev/sdd')
  --sdk                 Location of images (for example '/home/user/mel/build/tmp/deploy/images/p1010rdb/').
  --rootfs		Name of file-system image (for example 'console-image').
  --dtb                 Name of devicetree binary specific to the target platform (for example 'uImage-p1010rdb-pa.dtb').

Optional options:
  --version             Print version.
  --help                Print this help message.
"
  exit 1
}

check_if_main_drive ()
{
  mount | grep " on / type " > /dev/null
  if [ "$?" != "0" ]
  then
    echo "-- WARNING: not able to determine current filesystem device"
  else
    main_dev=`mount | grep " on / type " | awk '{print $1}'`
    echo "-- Main device is: $main_dev"
    echo $main_dev | grep "$device" > /dev/null
    [ "$?" = "0" ] && echo "++ ERROR: $device seems to be current main drive ++" && exit 1
  fi

}

# Check if the script was started as root or with sudo
user=`id -u`
[ "$user" != "0" ] && echo "++ Must be root/sudo ++" && exit

# Process command line...
while [ $# -gt 0 ]; do
  case $1 in
    --help | -h)
      usage $0
      ;;
    --device) shift; device=$1; shift; ;;
    --sdk) shift; sdkdir=$1; shift; ;;
    --dtb) shift; KERNEL_DEVICETREE=$1; shift; ;;
    --rootfs ) shift; ROOTFS_IMAGE="$1-${MACHINE}.tar.bz2"; shift; ;;
    --version) version $0;;
    *) copy="$copy $1"; shift; ;;
  esac
done

test -z $sdkdir && usage $0
test -z $device && usage $0
test -z $ROOTFS_IMAGE && usage $0
test -z $KERNEL_DEVICETREE && usage $0

if [ ! -d $sdkdir ]; then
   echo "ERROR: $sdkdir does not exist"
   exit 1;
fi

if [ ! -b $device ]; then
   echo "ERROR: $device is not a block device file"
   exit 1;
fi

check_if_main_drive

echo "************************************************************"
echo "*         THIS WILL DELETE ALL THE DATA ON $device        *"
echo "*                                                          *"
echo "*         WARNING! Make sure your computer does not go     *"
echo "*                  in to idle mode while this script is    *"
echo "*                  running. The script will complete,      *"
echo "*                  but your media be corrupted.            *"
echo "*                                                          *"
echo "*         Press <ENTER> to confirm....                     *"
echo "************************************************************"
read junk

for i in `ls -1 $device?*`; do
 echo "unmounting device '$i'"
 umount $i 2>/dev/null
done

execute "dd if=/dev/zero of=$device oflag=sync bs=1M count=1"

cat << END | fdisk $device
n
p
1
16384

w
END

# handle various device names.
PARTITION1=${device}1
if [ ! -b ${PARTITION1} ]; then
        PARTITION1=${device}p1
fi

# make partitions.
if [ -b ${PARTITION1} ]; then
	mkfs.ext3 -L "rootfs" ${PARTITION1}
else
	echo "Cant find rootfs partition in /dev"
fi

echo "Copying filesystem on ${PARTITION1}"
execute "mkdir -p /tmp/sdk/$$/rootfs"
execute "mount ${PARTITION1} /tmp/sdk/$$/rootfs"

execute "dd if=${sdkdir}/uImage of=${device} bs=512 seek=2048"
execute "dd if=${sdkdir}/${KERNEL_DEVICETREE} of=${device} bs=512 seek=1536"

if [ ! -f $sdkdir/${ROOTFS_IMAGE} ]
then
        ROOTFS_IMAGE=`echo $ROOTFS_IMAGE | sed "s:-${MACHINE}::"`
fi

if [ ! -f $sdkdir/${ROOTFS_IMAGE} ]; then
        echo "ERROR: failed to find rootfs [${ROOTFS_IMAGE}] tar in $sdkdir"
        ROOTFS_IMAGE=
        execute "umount /tmp/sdk/$$/root"
        exit 1
fi

echo "Extracting filesystem [${ROOTFS_IMAGE}] on ${PARTITION1} ..."
root_fs=`ls -1 $sdkdir/${ROOTFS_IMAGE}`
execute "tar xaf $root_fs -C /tmp/sdk/$$/rootfs"

sync
echo "unmounting ${PARTITION1}"
execute "umount /tmp/sdk/$$/rootfs"

execute "rm -rf /tmp/sdk/$$"
echo "completed!"
