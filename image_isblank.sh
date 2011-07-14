#!/bin/bash

scan="$1"

reference=~/Scans/white_100.tif
threshold=500
temptif=`mktemp /tmp/temp-XXXXXX`
difftif=`mktemp /tmp/diff-XXXXXX`
sub_folder=trash

rm -f "$temptif"
rm -f "$difftif"

if [ ! -f ${reference} ]; then
	convert -size 100x100 -background white -fill white xc:white ${reference}
fi

temptif="$temptif.tif"
difftif="$difftif.tif"

if [ ! -f $reference ]; then
    echo " ERROR: $reference is missing"
fi

# Removes hole-punch marks and 0.25" border from page
left=250
right=4830
upper=2490
lower=4150
radius=120

right_top="${right},${upper} $((right+radius)),$((upper+radius))"
right_bottom="${right},${lower} $((right+radius)),$((lower+radius))"
left_top="${left},${upper} $((left+radius)),$((upper+radius))"
left_bottom="${left},${lower} $((left+radius)),$((lower+radius))"

if [ -f "${scan}" ]; then

    scan_folder=`dirname $1`
    pushd ${scan_folder} > /dev/null
        scan_folder=`pwd`
    popd > /dev/null

    if [ ! -d ${scan_folder}/${sub_folder} ]; then
        mkdir ${scan_folder}/${sub_folder}
    fi
    trash_folder=${scan_folder}/${sub_folder}

    nice convert $scan -fill white \
        -draw "circle $right_top" \
        -draw "circle $right_bottom" \
        -draw "circle $left_top" \
        -draw "circle $left_bottom" \
        -shave 150x150 \
	    -resample 100x100 \
	    -format tiff \
	    -size 800x1050 \
        -type BiLevel \
        $temptif

    # Compare de-holed + de-bordered tiff with pure white tiff
    black_pxl=`compare $reference $temptif -metric AE $difftif 2>&1 | head -n 1`
    rm -f $difftif
    rm -f $temptif

    # if the number is not scientific notation, then...
    if [ "$black_pxl" == "${black_pxl/e/}" ]; then
	    if (( $black_pxl < $threshold )); then
		    if [ "$2" == "--delete" ]; then
			    rm -f "$scan"
		    else
			    mv "$scan" "${trash_folder}"
		    fi
	    fi
    fi

fi
