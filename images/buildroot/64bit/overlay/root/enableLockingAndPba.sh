#!/usr/bin/env sh

#expected args:
#$1: admin1 password
#$2: user1 password
#$3: SSD drive

set -ex

printHelp()  {
    echo "$0 ADMIN1_PASSWORD USER1_PASSWORD SSD_DRIVE"
    echo "if you cannot take ownership of SSD try with:"
    echo "sedutil-cli --yesIreallywanttoERASEALLmydatausingthePSID <PSID> <device>"
    echo ">> The PSID is a LONG LONG string printed on your Device (Physical ID)"
    echo ">> this command DO NOT DELETE anything if no ADMIN1 or SID password is enabled!"
}

if [ "$1" == "-h" ]; then
    printHelp
    exit 0
fi

if [ $# -lt 3 ]; then
    printHelp
    exit 1
fi

gunzip /usr/sedutil/UEFI64-*.img.gz

sedutil-cli --initialsetup $1 $3
sedutil-cli --enablelockingrange 0 $1 $3
sedutil-cli --setlockingrange 0 LK Admin1 $1 $3
sedutil-cli --setmbrdone off Admin1 $1 $3
sedutil-cli --loadpbaimage $1 /usr/sedutil/UEFI64-*.img $3
sedutil-cli --setsidpassword $1 $1 $3
sedutil-cli --setmbrdone on Admin1 $1 $3

sedutil-cli --setPassword $1 User1 $2 $3
sedutil-cli --addUserToLockingACEs User1 $1 $3
sedutil-cli --enableUser $1 User1 $3

echo "Setup completed. To verify the setup poweroff the machine before restarting it"
