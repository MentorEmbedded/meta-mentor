#! /bin/sh
# Script to create special partition for bootloader of Altera Cyclone-5.
#
# Author: Fahad Usman, Mentor Graphics Inc.

# Licensed under terms of GPLv2
#

VERSION="0.1"

SELF=$(basename $0)
SELFPATH=$(dirname $0)

binary="./u-boot-spl-mkpimage.bin"

BOOT_PT_NUM="3"
BOOT_PT_TYPE="a2"
BOOT_PT_START="2048"
BOOT_PT_END="32775"

P="p"

# only Superuser can run this script
if [ `whoami` != "root" ] ; then
    echo "Please run this script as a Superuser."
    exit -1
fi

usage ()
{
  echo "
Usage: `basename $0` -d device [-f binary]
"
  exit 1
}

# Process command line...
while [ $# -gt 0 ]; do
  case $1 in
    --help | -h)
      usage $0
      ;;
    -d) shift; device=$1; shift; ;;
    -f) shift; binary=$1; shift; ;;
    *) copy="$copy $1"; shift; ;;
  esac
done

test -z $device && usage $0

if [ ! -b $device ]; then
   echo "ERROR: $device is not a block device file"
   exit 1;
fi

if [ -b ${device}1 ]; then
  P=""
else
  P="p"
fi

if [ ! -f ${binary} ]; then
  echo "ERROR: failed to find the boot loader image file: \"${binary}\""
  exit 1;
fi

echo "*****************************************************************"
echo "*         This script is specifically written to be used        *"
echo "*         with SD-Card prepared with wic image generated        *"
echo "*         by building MEL for Altera Cyclone V target.          *"
echo "*                                                               *"
echo "*         Make sure you have prepared the SD-Card following     *" 
echo "*         the instructions in the MEL getting started guide     *"
echo "*         for Altera Cyclone V.                                 *"
echo "*                                                               *"
echo "*         This script alters the partition table of SD-Card     *"
echo "*         and the changes made by this script may not be        *"
echo "*         reversible                                            *"
echo "*                                                               *"
echo "*         Press <ENTER> to confirm....                          *"
echo "*****************************************************************"
read junk

cat <<END | fdisk ${device} >/dev/null 2>&1
n
p
${BOOT_PT_NUM}
${BOOT_PT_START}
${BOOT_PT_END}
t
${BOOT_PT_NUM}
${BOOT_PT_TYPE}
w
END

dd if=${binary} of=${device}${P}${BOOT_PT_NUM} 2>/dev/null

echo "completed!"
exit 0
