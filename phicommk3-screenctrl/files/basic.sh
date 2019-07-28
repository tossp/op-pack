#!/bin/sh
. /etc/os-release

PRODUCT_NAME_FULL=$(cat /etc/board.json | jsonfilter -e "@.model.name")
PRODUCT_NAME="TS ${PRODUCT_NAME_FULL#* }"

WAN_IFNAME=$(uci get network.wan.ifname)
MAC_ADDR=$(ifconfig $WAN_IFNAME | grep -oE "([0-9A-Z]{2}:){5}[0-9A-Z]{2}")

HW_VERSION=${OPENWRT_DEVICE_REVISION}
FW_VERSION=${BUILD_ID}

echo $PRODUCT_NAME

if [ $(uci get k3screenctrl.@general[-1].cputemp) -eq 1 ]; then
    CPU_TEMP=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))
    echo $HW_VERSION $CPU_TEMP
else
    echo $HW_VERSION
fi

echo $FW_VERSION
echo $MAC_ADDR