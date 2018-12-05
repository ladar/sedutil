#!/bin/sh
if [ -d /dev/vc ]
	then
	for ttydev in /dev/vc/[0-9]*
		do
		kbd_mode -u -C ${ttydev}
	done
else
	for ttydev in /dev/tty[0-9]*
		do
		kbd_mode -u -C ${ttydev}
	done
fi
loadkeys -q fr
