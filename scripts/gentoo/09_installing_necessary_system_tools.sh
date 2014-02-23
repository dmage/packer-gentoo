#!/bin/sh -efux
#
# http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=9
#
. /etc/profile

# System Logger
chroot "$CHROOT" emerge syslog-ng
chroot "$CHROOT" rc-update add syslog-ng default

# Optional: Cron Daemon
# emerge cronie
# rc-update add cronie default

# Optional: File Indexing
# emerge mlocate

# Optional: Remote Access
rc-update add sshd default

# nano -w /etc/inittab
## SERIAL CONSOLES
#s0:12345:respawn:/sbin/agetty 9600 ttyS0 vt100
#s1:12345:respawn:/sbin/agetty 9600 ttyS1 vt100

# File System Tools
# TODO

# Networking Tools
chroot "$CHROOT" emerge dhcpcd
#emerge ppp
