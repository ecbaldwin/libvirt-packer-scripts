#!/bin/bash

# I love serial ports. Enable serial port console on this vm.
systemctl enable serial-getty@ttyS0.service
grubconf=/etc/default/grub
if ! grep -q GRUB_CMDLINE_LINUX=.*console $grubconf
then
    # This file seems to be shell compatible
    source $grubconf
    GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX+$GRUB_CMDLINE_LINUX }console=tty0 console=ttyS0,115200n8"
    echo $GRUB_CMDLINE_LINUX
    sed -i 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="'"$GRUB_CMDLINE_LINUX"'"/' $grubconf
else
    echo >&2 "$grubconf already has console lines. Skipping adding serial port to kernel params!"
fi

if ! grep -q ^GRUB_TERMINAL= $grubconf && ! grep -q ^GRUB_SERIAL_COMMAND= $grubconf
then
    sed -i 's/^#GRUB_TERMINAL=.*/GRUB_TERMINAL=serial\nGRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"/' $grubconf
else
    echo >&2 "$grubconf already has terminal stuff set. Skipping adding serial port to grub!"
fi
update-grub
