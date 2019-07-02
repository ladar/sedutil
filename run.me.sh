# git clone https://github.com/ckamm/sedutil && cd sedutil && autoreconf --install
./configure && make all && cd images && ./getresources && ./buildpbaroot && ./buildbios && ./buildUEFI64 && mkdir UEFI64 && mv UEFI64-1.15*.img.gz UEFI64 && ./buildrescue Rescue32 && ./buildrescue Rescue64 && cd ..
while true; do printf "\a"; sleep 2; done
