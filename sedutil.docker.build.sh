#!/bin/bash

# Setup the build environment.
docker build -t sedutil.build .

# Perform the build. The privileged flag is required so create/mount loop devices,
# which is how the PBA image is created.
docker run --rm -it -v $PWD/:/sedutil --privileged sedutil.build

# Assuming the build worked, Extract the PBA images/sedutil packages.
docker cp sedutil.build:/sedutil/images/BIOS32 images/
docker cp sedutil.build:/sedutil/images/UEFI64 images/
docker cp sedutil.build:/sedutil/sedutil-1.16.0.tar.gz sedutil-1.16.0.tar.gz
