# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "generic/ubuntu1804"

  config.vm.provider :libvirt do |v, override|
    v.driver = "kvm"
    v.video_vram = 256
    v.memory = 12384
    v.cpus = 12
    v.volume_cache = "unsafe"
  end
  
  config.vm.provision "shell", run: "always", privileged: true, inline: <<-SHELL
    sudo su
    export DEBIAN_FRONTEND=noninteractive
    export DEBCONF_NONINTERACTIVE_SEEN=true
    apt-get update
    apt-get upgrade -y
    apt-get install -y build-essential
    apt-get install -y autoconf automake bison cmake cmake-curses-gui flex gdb gettext git libassimp-dev libboost-all-dev libcos4-dev libeigen3-dev libeigen3-doc libffi-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libjpeg-dev liblua5.3-dev libode-dev libogre-1.9-dev libomniorb4-dev libpulse-dev libqt5svg5-dev libqt5x11extras5-dev libreadline-dev libsdformat6-dev libsndfile1-dev libssl-dev libxfixes-dev libyaml-dev linux-headers-$(uname -r) lua5.3 lua-posix nasm  omniidl omniidl-python omniorb-nameserver pkg-config python2.7-dev python3-dev python3-numpy python-numpy python-omniorb qt5-default qt5-style-plugins uuid-dev yasm zlib1g-dev autoconf2.64 autogen mtools extlinux dosfstools libcrypt-passwdmd5-perl libdigest-sha-perl isolinux usb-creator-common gdisk genisoimage udisks2 wodim xorriso floppyd reiserfsprogs exfat-utils libc6-dev-amd64 cdck autoconf-archive gnu-standards libtool gnuplot lrzip binfmt-support gvfs gvfs-backends apt-file hwinfo fbset
  SHELL

  config.vm.provision "shell", run: "always", privileged: false, inline: <<-SHELL
    
    cd $HOME && ([ -d sedutil ] && rm -rf $HOME/sedutil)
    git clone https://github.com/ladar/sedutil && cd sedutil

    if [ ! -f ./configure ]; then autoreconf --install ; fi
    ./configure && make all && cd images && ./getresources && ./buildpbaroot && ./buildbios && ./buildUEFI64 && mkdir UEFI64 && mv UEFI64-1.15*.img.gz UEFI64 && ./buildrescue Rescue32 && ./buildrescue Rescue64 && cd ..
    sudo updatedb &
    printf "\\\\n\\\\nAll done.\\\\n\\\\n\\\\n"
  SHELL

end
