#!/bin/bash

# Name: sedutil.sleep.example.sh
# Author: Ladar Levison

# Description: This is script collects the SED password and provides preps
#   multiple drives for a forthcoming system sleep/suspend on Linux systems.
#   Note that SED OPAL block device support must be enabled when the kernel
#   is compiled. This script is provided as an example. You need to replace
#   device paths below ("/dev/nvme0n1" and "/dev/nvme1n1") with the correct
#   values. You may also want to setup and utilize a SED user, instead of
#   of the admin locking range.

# Systemd password input logic, with Bash read as a fallback.
# if [ "`which systemd-ask-password &>/dev/null`" == "0" ]; then
# PASSWORD=$(systemd-ask-password --timeout=60 "Password: ")
# RESULT=$?
# else
#   read -r -t 60 -e -p "Password: " -s PASSWORD
#   RESULT=$?
#   echo "$PASSWORD" | sed -r 's/./*/g'
# fi

# Always use the less interactive, classic password collection logic.
# read -r -t 60 -e -p "Password: " -s PASSWORD
# RESULT=$?
# echo "$PASSWORD" | sed -r 's/./*/g'

# Make sure we have a valid password for sedutil below.
if [ -z PASSWORD ] || [ "$PASSWORD" == "" ] || [ "$RESULT" != 0 ]; then
  tput setaf 1 ; printf "\nPassword collection failed.\n\n" ; tput sgr0
  exit 1
fi

# Attempt the first unlock operation. If it fails, we don't bother attempting it again.
echo "$PASSWORD" | sudo /usr/local/sbin/sedutil-cli -s --prepareForS3Sleep 0 Admin1 /dev/nvme0n1 | grep -Ev 'Please enter password|^[[:blank:]]*$'
[ "${PIPESTATUS[1]}" != 0 ] && exit 2

echo "$PASSWORD" | sudo /usr/local/sbin/sedutil-cli -s --prepareForS3Sleep 0 Admin1 /dev/nvme1n1 | grep -Ev 'Please enter password|^[[:blank:]]*$'
[ "${PIPESTATUS[1]}" != 0 ] && exit 2

tput setaf 2 ; printf "OPAL drives are ready to fall asleep.\n\n" ; tput sgr0
exit 0
