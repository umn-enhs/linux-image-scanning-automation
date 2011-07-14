#!/bin/bash

# This is the server-side processing script for incoming scans
# Manual rotation should be done before this runs.

folder="$1"
install_base=`dirname "$0"`
if [ "${install_base}" == "." ];  then
	install_base=`pwd`
fi

echo "${install_base}"
PATH="$PATH:${install_base}"

if [ -d $folder  ]; then

    pushd $folder > /dev/null
       scan_folder=`pwd`
    popd > /dev/null

	pushd ${scan_folder} > /dev/null
		for scan in *.tif; do
		
			# If it's too big, shrink it
			file_size=$(stat -c%s $scan)
			if ((( $file_size > 5000000 ))); then
				echo "Compressing huge image..."
				nice mogrify -monochrome $scan
			fi
		
		
            # Remove Blank Pages
            #image_isblank.sh "$scan" --delete
            image_isblank.sh "$scan"
            
            echo "Processing image $scan :"

            # If page was blank, the rest doesn't matter
            if [ -f $scan ]; then
                # Find Barcodes
                echo "  Scanning for bar codes..."
                image_barcode.sh "$scan"
                # Straighten
                echo "  Straigtening..."
                image_deskew.sh "$scan"
                # OCR
                # echo "  Extracting text..."
                # image_ocr.sh all "$scan"
                
                # Thumbnail
                echo "  Creating thumbnail..."
                image_thumbnail.sh "$scan"
                
                echo "  Compressing..."
                # Compress using LZW (saves ~80% space)
                image_shrink.sh "$scan"
                
                echo "  Done."
            else
                echo "Blank Page $scan removed."                
            fi

		done
	popd > /dev/null
fi

