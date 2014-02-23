#!/bin/sh -efux
#
# http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=10
#
. /etc/profile

# Using GRUB2
chroot "$CHROOT" emerge sys-boot/grub
chroot "$CHROOT" grub2-install /dev/sda
chroot "$CHROOT" grub2-mkconfig -o /boot/grub/grub.cfg

# Rebooting the System
umount -l "$CHROOT"/dev{/shm,/pts,}
umount -l "$CHROOT"{/boot,/proc,}
