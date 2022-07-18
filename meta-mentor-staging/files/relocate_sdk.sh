#!/bin/bash

# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

target_sdk_dir="$(cd "$(dirname "$0")" && pwd -P)"
default_sdk_dir="@SDKPATH@"

# fix environment paths
for env_setup_script in $target_sdk_dir/environment-setup-*; do
    if [ ! -e "$env_setup_script" ]; then
        continue
    fi
    sed -e "s:$default_sdk_dir:$target_sdk_dir:g" -i "$env_setup_script"
done

if ! xargs --version > /dev/null 2>&1; then
    echo "xargs is required by the relocation script, please install it first. Abort!"
    exit 1
fi

scriptdir="$target_sdk_dir" eval "$(grep 'OECORE_NATIVE_SYSROOT=' "$env_setup_script" | head -n 1)"
native_sysroot="$OECORE_NATIVE_SYSROOT"

# replace $default_sdk_dir with the new prefix in all text files: configs/scripts/etc.
# replace the host perl with SDK perl.
for replace in "$target_sdk_dir -maxdepth 1" "$native_sysroot"; do
    find $replace -type f 2>/dev/null
done | xargs -n100 file | grep ":.*\(ASCII\|script\|source\).*text" | \
    awk -F':' '{printf "\"%s\"\n", $1}' | \
    grep -Ev "$target_sdk_dir/(environment-setup-*|relocate_sdk*|${0##*/})" | \
    xargs -n100 sed -i \
    -e "s:$default_sdk_dir:$target_sdk_dir:g" \
    -e "s:^#! */usr/bin/perl.*:#! /usr/bin/env perl:g" \
    -e "s: /usr/bin/perl: /usr/bin/env perl:g"

if [ -e "$native_sysroot/lib" ]; then
    for py in python python2 python3; do
        PYTHON=`which ${py} 2>/dev/null`
        if [ $? -eq 0 ]; then
            break;
        fi
    done

    if [ x${PYTHON} = "x"  ]; then
        echo "SDK could not be relocated.  No python found."
        exit 1
    fi

    dl_path=$(find $native_sysroot/lib -name "ld-linux*")
    if [ "$dl_path" = "" ] ; then
            echo "SDK could not be set up. Relocate script unable to find ld-linux.so. Abort!"
            exit 1
    fi

    find $native_sysroot -type f \
            \( -perm -0100 -o -perm -0010 -o -perm -0001 \) -print0 | \
            xargs -0 ${PYTHON} ${env_setup_script%/*}/relocate_sdk.py $target_sdk_dir $dl_path
    if [ $? -ne 0 ]; then
        echo "Failed to run ${env_setup_script%/*}/relocate_sdk.py. Abort!"
        exit 1
    fi

    # change all symlinks pointing to $default_sdk_dir
    for l in $(find $native_sysroot -type l); do
        ln -sfn $(readlink $l|sed -e "s:$default_sdk_dir:$target_sdk_dir:") $l
        if [ $? -ne 0 ]; then
            echo "Failed to setup symlinks. Relocate script failed. Abort!"
            exit 1
        fi
    done
fi

# Execute post-relocation script
post_relocate="$target_sdk_dir/post-relocate-setup.sh"
if [ -e "$post_relocate" ]; then
    sed -e "s:$default_sdk_dir:$target_sdk_dir:g" -i $post_relocate
    /bin/sh $post_relocate "$target_sdk_dir" "$default_sdk_dir"
    if [ $? -ne 0 ]; then
        echo "Failed to run $post_relocate. Abort!"
        exit 1
    fi
    rm -f $post_relocate
fi
