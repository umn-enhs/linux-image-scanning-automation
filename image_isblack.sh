#!/bin/bash

scan="$1"

threshold=500
temptif=`mktemp /tmp/temp-XXXXXX`
difftif=`mktemp /tmp/diff-XXXXXX`
newref=`mktemp /tmp/refi-XXXXXX`
sub_folder=trash

rm -f "$temptif"
rm -f "$difftif"
rm -f "$newref"

temptif="$temptif.tif"
difftif="$difftif.tif"
newref="$newref.tif"

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

    nice convert $scan \
        -shave 150x150 \
	-resample 100x100 \
	-format tiff \
	-size 800x1050 \
        -type BiLevel \
        $temptif

    temptif_size=`tiffinfo $temptif | grep "Image Width:" | cut -d " " -f 5,8 | sed -e 's/ /x/'`

    #cp $temptif `basename $scan .tif`.choped-shrunk-and-deholed.tif
    nice gm convert -size $temptif_size \
	    -density 100x100 \
	    -background black \
	    -fill black xc:black ${newref}

    # Compare de-holed + de-bordered tiff with pure white tiff
    # ImageMagick version
    black_pxl=`compare $newref $temptif -metric AE $difftif 2>&1 | head -n 1`
    # Graphics Magick version
    #   -metric
    #          maximum absolute error (MAE)
    #          mean square error (MSE)
    #          root mean square error (RMSE)
    #          signal to noise ratio (SNR)
    #          peak signal to noise ratio (PSNR)
    #black_pxl=`gm compare $newref $temptif -metric MSE $difftif 2>&1 | grep Total:`

    # echo "black pixels: $black_pxl vs $threshold (threshold)"
    rm -f $difftif
    rm -f $temptif

    # if the number is not scientific notation, then...
    if [ "$black_pxl" == "${black_pxl/e/}" ]; then
	    if (( $black_pxl < $threshold )); then
		echo "$scan is a black page."
		    if [ "$2" == "--delete" ]; then
			    rm -f "$scan"
		    else
			    mv "$scan" "${trash_folder}"
		    fi
	    fi
    fi

fi
