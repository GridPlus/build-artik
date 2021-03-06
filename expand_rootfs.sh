#!/bin/bash

set -x

if [ "$#" != "1" ]; then
	echo "Please specify a device node of sdcard"
	echo "ex) sudo ./expand_rootfs.sh /dev/sdc"
	echo "You can see the node from lsblk command"
	exit 0
fi

DEVICE=$1

for disk in ${DEVICE}*
do
	sudo umount $disk
done

START_SECT=`sudo fdisk -l $DEVICE | grep ${DEVICE}3 | awk '{ print $2 }'`

sudo fdisk $DEVICE <<EOF
p
d
3
n
p
3
$START_SECT

w
EOF

sync; sync

sudo e2fsck -f -y ${DEVICE}3
sudo resize2fs ${DEVICE}3

sync; sync

echo "Resize complete"
