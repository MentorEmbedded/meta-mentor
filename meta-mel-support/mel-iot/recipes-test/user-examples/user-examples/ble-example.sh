#!/bin/sh

MY_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
. ${MY_DIR}/../sh-test-lib

DEVICE="hci0"
MAC_BLE=""

usage() {
    echo "Usage: $0 [-d <hci-dev>]" 1>&2
    exit 1
}

while getopts "d:h:" o; do
  case "$o" in
    d) DEVICE="${OPTARG}" ;;
    *) usage ;;
  esac
done

find_hcidev() {
    info_msg "Checking ${DEVICE} availability..."
    hciconfig "${DEVICE}" &> /dev/null
    exit_on_fail "${DEVICE} exists" "${DEVICE} doesn't exist. Please verify if Bluetooth 4.0 dongle is attached to the target!"
}

hciconfig_up() {
    info_msg "Running hciconfig-up..."
    hciconfig "${DEVICE}" up
    sleep 1
    hciconfig "${DEVICE}" | grep -q "UP RUNNING"
    exit_on_fail "${DEVICE} is UP now" "${DEVICE} is not working properly!"
}

hciconfig_down() {
    info_msg "Running hciconfig-down..."
    hciconfig "${DEVICE}" down
    sleep 1
    hciconfig "${DEVICE}" | grep -q DOWN
    exit_on_fail "${DEVICE} is DOWN now" "${DEVICE} is not working properly!"
}

BLE_scan() {
    ( hcitool lescan & sleep 5 ; kill -INT $! ) &> scan_result.txt
    MAC_BLE=$(grep "SensorTag" scan_result.txt | head -1 | cut -f1 -d ' ')
    [ ! -z ${MAC_BLE} ]
    exit_on_fail "BLE-scan complete" "BLE-scan failed!"
}

info_msg "About to run HCI examples..."

pkgs="bluez5-noinst-tools"
check_deps "${pkgs}"

# Disable all HCI devices except the one in use
HCI_DEVS=$(hciconfig | grep hci | cut -f1 -d":")
for hci_dev in ${HCI_DEVS}; do
    if [ "${hci_dev}" != "${DEVICE}" ]; then
        hciconfig "${hci_dev}" down
    fi
done

find_hcidev
hciconfig_down
hciconfig_up
BLE_scan

# Start the luxometer sensor on SensorTag.
value=01
btmgmt le on &> /dev/null
gatttool -i "${DEVICE}" -b "${MAC_BLE}" --char-write-req -a 0x0044 -n "${value}"
gatttool -i "${DEVICE}" -b "${MAC_BLE}" --char-read -a 0x0044 | grep -q "${value}"
check_return "BLE-write complete" "BLE-write failed!"

# Read the measurement value from the luxometer sensor.
i=0
while [ ${i} -lt 3 ]; do
    gatttool -i "${DEVICE}" -b "${MAC_BLE}" --char-read -a 0x0041
    if [ $? -lt 0 ]; then
        report_fail "BLE-read failed!"
    fi
    i=$(( i+1 ))
    sleep 1
done

report_successful "BLE-read complete"

