#!/bin/sh -efux
#
# http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=7
#
. /etc/profile

# Installing the Sources
chroot "$CHROOT" emerge gentoo-sources

# Using genkernel
chroot "$CHROOT" emerge genkernel
chroot "$CHROOT" genkernel all
