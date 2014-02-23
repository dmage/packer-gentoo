#!/bin/sh -efux
#
# http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=4
#
. /etc/profile

# Creating Partitions
TYPE_BIOS_BOOT=ef02
TYPE_LINUX=8300
TYPE_LINUX_SWAP=8200

sgdisk -n 1:0:+2M   -t 1:$TYPE_BIOS_BOOT  -c 1:"bios-boot"  \
       -n 2:0:+128M -t 2:$TYPE_LINUX      -c 2:"linux-boot" \
       -n 3:0:+1G   -t 3:$TYPE_LINUX_SWAP -c 3:"swap"       \
       -n 4:0:0     -t 4:$TYPE_LINUX      -c 4:"linux-root" \
       -p /dev/sda

sleep 1

# Applying a Filesystem to a Partition
mkfs.ext2 /dev/sda2
mkfs.ext4 /dev/sda4

# Activating the Swap Partition
mkswap /dev/sda3
swapon /dev/sda3

# Mounting
mount /dev/sda4 "$CHROOT"
mkdir "$CHROOT/boot"
mount /dev/sda2 "$CHROOT/boot"
