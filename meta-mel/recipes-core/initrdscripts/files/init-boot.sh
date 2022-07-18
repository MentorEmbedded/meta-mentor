#!/bin/sh

# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

PATH=/sbin:/bin:/usr/sbin:/usr/bin

mkdir -p /proc
mkdir -p /sys
mount -t proc proc /proc
mount -t sysfs sysfs /sys

# mount devtmpfs 
mount -n -o mode=0755 -t devtmpfs none "/dev"

# get name of active terminal
CONSOLE=`cat /sys/devices/virtual/tty/console/active | cut -d " " -f2`

# run shell on active terminal
setsid sh -c "exec sh </dev/$CONSOLE >/dev/$CONSOLE 2>&1"
