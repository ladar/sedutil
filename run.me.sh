#!/usr/bin/env sh
# git clone https://github.com/ckamm/sedutil && cd sedutil
if [ ! -f ./configure ]; then autoreconf --install ; fi
./configure && make all && cd images && ./getresources && ./buildpbaroot && ./buildbios && ./buildUEFI64 && mkdir UEFI64 && mv UEFI64-1.16*.img.gz UEFI64 && ./buildrescue Rescue32 && ./buildrescue Rescue64 && cd ..
printf "\n\nAll done.\nMaking noise so you know we're done.\n\n\n"
while true; do printf "\a"; sleep 2; done
