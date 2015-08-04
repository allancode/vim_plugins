#! /bin/bash

echo "adb wait-for-device"
adb wait-for-device
adb devices
sleep 2

CUR_TIME=$(date +%Y%m%d_%H%M%S)
BUGREPORT_FILE=bugreport_${CUR_TIME}.bugreport
LOGCAT_FILE=logcat_${CUR_TIME}.logcat

(adb bugreport |tee ${BUGREPORT_FILE})
clear
(adb logcat -v time |tee ${LOGCAT_FILE})

