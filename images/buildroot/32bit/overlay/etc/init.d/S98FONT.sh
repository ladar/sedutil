#!/bin/sh
clear
[ -f /sys/devices/system/cpu/intel_pstate/no_turbo ] && (echo '1' > /sys/devices/system/cpu/intel_pstate/no_turbo)
/usr/sbin/setfont "/usr/share/consolefonts/Uni1-VGA32x16.psf" -C /dev/console &>/dev/null
for i in /dev/tty[0-9]*; do
/usr/sbin/setfont "/usr/share/consolefonts/Uni1-VGA32x16.psf" -C ${i} &>/dev/null
done

