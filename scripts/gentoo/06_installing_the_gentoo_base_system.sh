#!/bin/sh -efux
#
# http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=6
#
. /etc/profile

# Optional: Selecting Mirrors
# TODO

# Copy DNS Info
cp -L /etc/resolv.conf "$CHROOT/etc/"

# Mounting the necessary Filesystems
mount -t proc proc "$CHROOT/proc"
mount --rbind /sys "$CHROOT/sys"
mount --rbind /dev "$CHROOT/dev"

# Prepare new Environment
chroot "$CHROOT" env-update

# Installing a Portage Snapshot
chroot "$CHROOT" emerge-webrsync

# Optional: Updating the Portage tree
if false; then
    chroot "$CHROOT" emerge --sync
fi

# Reading News Items
# TODO

# Choosing the Right Profile
# TODO

# Configuring the USE variable
# TODO

# Timezone
echo "$TIMEZONE" | chroot "$CHROOT" tee /etc/timezone
ls -al /etc/localtime
chroot "$CHROOT" emerge --config sys-libs/timezone-data
ls -al /etc/localtime

# Configure locales
chroot "$CHROOT" tee /etc/locale.gen <<END
en_US.UTF-8 UTF-8
en_US ISO-8859-1
ru_RU.KOI8-R KOI8-R
ru_RU.UTF-8 UTF-8
ru_RU ISO-8859-5
END
chroot "$CHROOT" locale-gen
chroot "$CHROOT" eselect locale set en_US.UTF-8
chroot "$CHROOT" env-update
