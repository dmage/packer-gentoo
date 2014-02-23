#!/bin/sh -efux
#
# http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=5
#
. /etc/profile

cd /mnt/gentoo

# Unpacking the Stage Tarball
time tar xpf "$STAGE3_FILE" && rm -f "$STAGE3_FILE"

# Configuring the Compile Options
# TODO
