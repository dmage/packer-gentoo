#!/bin/sh -efux
#
# http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=8
#
. /etc/profile

# Filesystem Information
chroot "$CHROOT" tee /etc/fstab <<END
/dev/sda2   /boot       ext2    defaults,noatime    0 2
/dev/sda3   none        swap    sw                  0 0
/dev/sda4   /           ext4    noatime             0 1
END

# Host name, Domainname, etc
# TODO

# Configuring your Network
# TODO

# Disabling Cryptic Network Interace Names
# http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
chroot "$CHROOT" ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules   # for udev v197 through v208
chroot "$CHROOT" ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules  # for udev v209+

# Automatically Start Networking at Boot
chroot "$CHROOT" ln -s net.lo /etc/init.d/net.eth0
chroot "$CHROOT" rc-update add net.eth0 default

# Root Password
chroot "$CHROOT" passwd <<END
vagrant
vagrant
END

# System Information
# TODO
