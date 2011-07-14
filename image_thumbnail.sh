#!/bin/bash

scan="$1"
sub_folder=thumbnails

# Resizes scans for permanent storage
if [ -f "$scan" ]; then

    scan_folder=`dirname $1`
    pushd ${scan_folder} > /dev/null
        scan_folder=`pwd`
    popd > /dev/null

    if [ ! -d ${scan_folder}/${sub_folder} ]; then
        mkdir ${scan_folder}/${sub_folder}
    fi
    thumb_folder=${scan_folder}/${sub_folder}

    pushd ${scan_folder} > /dev/null
	    thumbname="`basename $scan .tif`.png"

        if [ ! -f "${thumb_folder}/${thumbname}" ]; then
            nice gm convert "${scan}" -resize 320x320 -quality 90 -format png "${thumb_folder}/${thumbname}"
	    fi
    popd > /dev/null
fi

