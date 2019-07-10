# About SEDutil

The sedutil project provides a CLI tool (`sedutil-cli`) capable of setting up and managing self encrypting drives (SEDs) that comply with the TCG OPAL 2.00 standard. This project also provides a pre-boot authentication image (`linuxpba`) which can be loaded onto an encrypted disk's shadow MBR. This pre-boot authentication image allows the user enter their password and unlock SED drives during the boot process. **Using this tool can make data on the drive inaccessible!**

## Setup

To configure a drive, load a compatible [RECOVERY](https://github.com/Drive-Trust-Alliance/sedutil/releases) image onto a USB drive with the following commands:

```
curl -L -o RESCUE64-1.15.1-87-SHA512.img.gz https://github.com/ladar/sedutil/releases/download/1.15.1-87/RESCUE64-1.15.1-87-SHA512.img.gz
gunzip RESCUE64-1.15.1-87-SHA512.img.gz
sudo dd if=RESCUE64-1.15.1-87-SHA512.img of=/dev/sd? bs=1k
sudo eject /dev/sd?
```

Be sure to replace the **`?`** with the appropriate device letter. After creating the boot stick, reboot the target computer. Ensure the computer has **UEFI** and **CSM** support enabled before booting. When the recovery image has finished booting, you will see a login prompt. Type `root` to login and begin the setup process. To configure your drive run the following commands:

```
gunzip /usr/sedutil/UEFI64-*.img.gz

sedutil-cli --initialsetup PASSWORD /dev/nvme?
sedutil-cli --enablelockingrange 0 PASSWORD /dev/nvme?
sedutil-cli --setlockingrange 0 LK Admin1 PASSWORD /dev/nvme?
sedutil-cli --setmbrdone off Admin1 PASSWORD /dev/nvme?
sedutil-cli --loadpbaimage PASSWORD /usr/sedutil/UEFI64-*.img /dev/nvme?
sedutil-cli --setsidpassword PASSWORD PASSWORD /dev/nvme?
sedutil-cli --setmbrdone on Admin1 PASSWORD /dev/nvme?
poweroff
```

And the setup process is complete. Be sure to replace the **`?`** with the drive number (typically 0). If you aren't using an NVME drive, update the entire device path accordingly. Replace **`PASSWORD`**  with your own randomly generated string of 40 or more characters. Note that if you want to setup a unique user password, without permission for any administrative functions, replace the second instance of **`PASSWORD`** with the user password when you execute the `--setsidpassword` command.


## Origin

This version of sedutil is based off the original [@dta](https://github.com/Drive-Trust-Alliance/sedutil/) implementation. A number of bug fixes, security patches, and pull requests were incorporated by [@cyrilvanersche](https://github.com/CyrilVanErsche/sedutil/) and then subsequently [@ckamm](https://github.com/ckamm/sedutil/). Most notably a USERID (aka `Admin1`)  is not required by some of the `sedutil-cli` operations.

## Notable Differences

Unique to this repo are the following modifications:

* Uses SHA512 instead of SHA1 when deriving the encryption key (see backwards compatibility below).
* UEFI boots will use 720p instead of the native resolution (critical for those with HiDPI screens).
* The boot authenticator allows a maximum of 3 password entry attempts per boot attempt.
* Networking support has been removed from the recovery and pre-boot authentication images.
* Small user interface improvements/cleanup.

## Backwards Compatibility

By default SHA512 is used. If your configuring a drive for the first time this is appropriate. For those wanting to use tools and boot images in this repo with drives that have already been configured using a different version of sedutil, be sure to download the SHA1 release files. If you want to compile your own binaries using SHA1, then you will need to replace `&cf_sha512` with `&cf_sha1` on this (line)[https://github.com/ladar/sedutil/blob/master/Common/DtaHashPwd.cpp#L58] before you begin the build process.

## Build Process

To compile your own version of `sedutil` you will need the standard development tools, an internet connection, and ~10 GB of disk space. Provided those requirements are met, you can simply run the following command:

```
git clone https://github.com/ladar/sedutil/ && cd sedutil && autoreconf --install && ./configure && make all && cd images && ./getresources && ./buildpbaroot && ./buildbios && ./buildUEFI64 && mkdir UEFI64 && mv UEFI64-1.15*.img.gz UEFI64 && ./buildrescue Rescue32 && ./buildrescue Rescue64 && cd ..
```

Or if you prefer a less compact version of the above command sequence:

```
git clone https://github.com/ladar/sedutil/
cd sedutil
autoreconf --install
./configure
make all
cd images
./getresources
./buildpbaroot
./buildbios
./buildUEFI64
mkdir UEFI64
mv UEFI64-1.15*.img.gz UEFI64
./buildrescue Rescue32
./buildrescue Rescue64
cd ..
```

The various recovery and boot images will be located in the `images` directory.

## Work in Progress

I hope to implement support for chain loading a Linux distros. I have experimented with a couple of patches that accomplish this, albeit with serious caveats that sitll need to be addressed before I can commit them to this repo. 

## Testing

I have only tested the boot images/release files on a ThinkPad with a Samsung EVO 970 NVMe drive. My testing has also focused primarily on the 64 bit UEFI images. While the other variants should work without issue, you should exercise caution, and if possible, test the release on a computer with data that is expendable.


