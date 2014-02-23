#!/bin/sh -efu

arch_menu=(
    x86 ''
    amd64 ''
)

DOWNLOAD_DIR=./http/gentoo
[ -f ./mirrorselect.conf ] && . ./mirrorselect.conf
GENTOO_MIRRORS="${GENTOO_MIRRORS-} http://distfiles.gentoo.org/"

if [ -z "${SYNC_SERVER-}" ]; then
    SYNC_SERVER="rsync.gentoo.org/gentoo-portage"
fi


select_arch() {
    __arch_count=`expr ${#arch_menu[*]} / 2`
    __dialog_width=30
    __dialog_height=`expr 7 + $__arch_count`
    __arch=`dialog --menu "Select architecture:" $__dialog_height $__dialog_width $__arch_count "${arch_menu[@]}" 2>&1 >/dev/tty`
    __err=$?
    clear

    if [ $__err -ne 0 ]; then
        echo "Au revoir!" >&2
        exit $__err
    fi

    eval "$1=\"\$__arch\""
}


download() {
    mkdir -p "$DOWNLOAD_DIR"

    __local_file="$DOWNLOAD_DIR/${2##*/}"
    if [ -e "$__local_file" ]; then
        find "$__local_file" -type f -size -1000 -delete
    fi

    for mirror in $GENTOO_MIRRORS; do
        if wget "$mirror$2" -O "$__local_file" -c; then
            eval "$1=\"\$__local_file\""
            return 0
        fi
    done

    echo "failed to download $2" >&2
    exit 1
}


download_and_verify() {
    download __file "$3"
    download __digest "$3.DIGESTS"

    __expected_sha512=`sed -ne '/^# SHA512/ { n; s/^\([0-9a-f]\{128\}\)  '${3##*/}'$/\1/p }' "$__digest"`
    __actual_sha512=`openssl dgst -sha512 "$__file" | cut -d ' ' -f2`
    if [ "$__actual_sha512" != "$__expected_sha512" ]; then
        echo "SHA512 MISMATCH: $__actual_sha512 != $__expected_sha512" >&2
        exit 1
    fi

    eval "$1=\"\$__file\""
    eval "$2=\"\$__actual_sha512\""
}


select_arch arch
if [ "$arch" == "x86" ]; then
    build_arch="x86"
    build_proc="i686"
    guest_os_type="Gentoo"
elif [ "$arch" == "amd64" ]; then
    build_arch="amd64"
    build_proc="amd64"
    guest_os_type="Gentoo_64"
else
    echo "Oops, unexpected architecture!" >&2
    exit 1
fi


autobuilds_path="/releases/$build_arch/autobuilds"
download iso_desc_file "$autobuilds_path/latest-install-$build_arch-minimal.txt"
latest_iso=`cat "$iso_desc_file" | grep -v '^#'`
latest_iso="20140116/install-amd64-minimal-20140116.iso"
download_and_verify iso_file iso_sha512 "$autobuilds_path/$latest_iso"

download stage3_desc_file "$autobuilds_path/latest-stage3-$build_proc.txt"
latest_stage3=`cat "$stage3_desc_file" | grep -v '^#'`
download_and_verify stage3_file stage3_sha512 "$autobuilds_path/$latest_stage3"


cat <<EOF >"latest.json"
{
    "guest_os_type": "$guest_os_type",
    "iso_url": "$iso_file",
    "iso_checksum": "$iso_sha512",
    "iso_checksum_type": "sha512",
    "timezone": "UTC",
    "sync_server": "$SYNC_SERVER",
    "stage3_file": "${stage3_file##*/}"
}
EOF
