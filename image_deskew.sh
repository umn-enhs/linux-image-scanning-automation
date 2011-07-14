#!/bin/bash

scan="$1"
temptif=`mktemp /tmp/temp-XXXXXXXX`
sub_folder=deskew

rm -f $temptif
temptif="$temptif.tif"

if [ -e "${scan}" ]; then

    scan_folder=`dirname ${scan}`
    pushd ${scan_folder} > /dev/null
        scan_folder=`pwd`
    popd > /dev/null

    if [ ! -d ${scan_folder}/${sub_folder} ]; then
        mkdir ${scan_folder}/${sub_folder}
    fi
    skew_log=${scan_folder}/${sub_folder}/log.txt
    
    scanfile=`basename "${scan}"`
    deskewed=0

    if [ -f "${skew_log}" ]; then
        grep -q "${scanfile}" "${skew_log}" && deskewed=1
    fi

    # Only de-skew files once.
    if [ "${deskewed}" == "0" ]; then
        # Find the skew
        skew=`nice tiff_findskew $scan`

        echo "${scanfile} ${skew}" >> "${skew_log}"

        # Now we need to reverse the skew angle
        skew=`echo "$skew * -1" | bc`
        # Use BC to calculate is skew is outside +/- 0.25 degrees
        offenough=`echo "$skew > 0.25 || $skew < -0.25" | bc`
        if [ "$offenough" == "1" ] ; then
            echo "Deskewing $scan by $skew degrees."
            nice tiff2rgba "${scan}" ${temptif}
            nice mogrify -adaptive-blur 3x3 -rotate ${skew} -type Bilevel ${temptif}
            mv ${temptif} "${scan}"
        fi
    fi
else
    echo "file $scan not found."
fi
