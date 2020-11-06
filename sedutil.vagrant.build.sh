#!/bin/bash

SKIP=0

which vagrant &> /dev/null
if [ "$?" != 0 ]; then
  printf "\nPlease install vagrant.\n\n"
  exit 1
fi

which virsh &> /dev/null
if [ "$?" == 0 ] && [ "`virsh version | head -1 | grep --only-matching libvirt`" == "libvirt" ] && [ "`vagrant plugin list | grep --extended-regexp --only-matching \"^vagrant-libvirt\"`" == "vagrant-libvirt" ]; then
  vagrant up --provider=libvirt || (printf "\n\n\nBuild attempt failed.\n\n" ; exit 1)
  SKIP=1
fi

which vboxmanage &> /dev/null
if [ "$?" == 0 ] && [ "$SKIP" == 0 ]; then
  vagrant up --provider=virtualbox || (printf "\n\n\nBuild attempt failed.\n\n" ; exit 1)
  SKIP=1
fi

which vmware &> /dev/null
if [ "$?" == 0 ] && [ "$SKIP" == 0 ] && [ "`vmware --version | head -1 | grep --only-matching --extended-regexp \"^VMware Workstation|^VMware Fusion\" | grep --only-matching --extended-regexp \"^VMware\"`" == "VMware" ] &&  [ "`vagrant plugin list | grep --extended-regexp --only-matching \"^vagrant-vmware-desktop\"`" == "vagrant-vmware-desktop" ]; then
  vagrant up --provider=vmware_desktop || (printf "\n\n\nBuild attempt failed.\n\n" ; exit 1)
  SKIP=1
fi

which prlctl &> /dev/null
if [ "$?" == 0 ] && [ "$SKIP" == 0 ] && [ "`vagrant plugin list | grep --extended-regexp --only-matching \"^vagrant-parallels\"`" == "vagrant-parallels" ]; then
  vagrant up --provider=parallels || (printf "\n\n\nBuild attempt failed.\n\n" ; exit 1)
  SKIP=1
fi

if [ "$SKIP" == 0 ] && [ "`vagrant plugin list --debug 2>&1 | grep --extended-regexp --only-matching \"Hyper-V provider\"`" == "Hyper-V provider" ]; then
  vagrant up --provider=hyperv || (printf "\n\n\nBuild attempt failed.\n\n" ; exit 1)
  SKIP=1
fi

if [ "$SKIP" == 1 ]; then
  vagrant ssh-config > config
  echo "get sedutil/sedutil-1.16.0.tar.gz sedutil-1.16.0.tar.gz" | sftp -q -F config default
  echo "get -r sedutil/images/BIOS32 images/BIOS32" | sftp -q -F config default
  echo "get -r sedutil/images/UEFI64 images/UEFI64" | sftp -q -F config default
  echo "get -r sedutil/images/RESCUE32 images/RESCUE32" | sftp -q -F config default
  echo "get -r sedutil/images/RESCUE64 images/RESCUE64" | sftp -q -F config default
fi
