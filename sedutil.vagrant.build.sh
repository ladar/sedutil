#!/bin/bash

which vagrant &> /dev/null
if [ "$?" != 0 ]; then
  printf "\nPlease install vagrant.\n\n"
  exit 1
fi

which virsh &> /dev/null
if [ "$?" == 0 ] && [ "`virsh version | head -1 | grep --only-matching libvirt`" == "libvirt" ] && [ "`vagrant plugin list | grep --extended-regexp --only-matching \"^vagrant-libvirt\"`" == "vagrant-libvirt" ]; then
  vagrant up --provider=libvirt
fi

which vboxmanage &> /dev/null
if [ "$?" == 0 ]; then
  vagrant up --provider=virtualbox
fi

which vmware &> /dev/null
if [ "$?" == 0 ] && [ "`vmware --version | head -1 | grep --only-matching --extended-regexp \"^VMware Workstation|^VMware Fusion\" | grep --only-matching --extended-regexp \"^VMware\"`" == "VMware" ] &&  [ "`vagrant plugin list | grep --extended-regexp --only-matching \"^vagrant-vmware-desktop\"`" == "vagrant-vmware-desktop" ]; then
  vagrant up --provider=vmware_desktop
fi

which prlctl &> /dev/null
if [ "$?" == 0 ] && [ "`vagrant plugin list | grep --extended-regexp --only-matching \"^vagrant-parallels\"`" == "vagrant-parallels" ]; then
  vagrant up --provider=parallels
fi

if [ "`vagrant plugin list --debug 2>&1 | grep --extended-regexp --only-matching \"Hyper-V provider\"`" == "Hyper-V provider" ]; then
  vagrant up --provider=hyperv
fi

vagrant ssh-config > config
echo get sedutil/sedutil-1.16.0.tar.gz sedutil-1.16.0.tar.gz | sftp -F config default
echo get sedutil/images/BIOS32 images/BIOS32 | sftp -F config default
echo get sedutil/images/UEFI64 images/UEFI64 | sftp -F config default
