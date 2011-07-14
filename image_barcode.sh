#!/bin/bash

# Note: This needs to be run against the 600dpi scans

scan="$1"
sub_folder=barcodes

if [ -f "$scan" ]; then

    scan_folder=`dirname $1`
    pushd ${scan_folder} > /dev/null
        scan_folder=`pwd`
    popd > /dev/null

    if [ ! -d ${scan_folder}/${sub_folder} ]; then
        mkdir ${scan_folder}/${sub_folder}
    fi
    barcode_folder=${scan_folder}/${sub_folder}
    
    pushd ${scan_folder} > /dev/null
	    scanname=`basename $scan .tif`
		
	    if [ ! -f "$barcode_folder/$scanname.barcode" ]; then
		    echo -n "Checking for Barcodes ..."
		    echo "Barcodes Scanned: `date`" > $barcode_folder/$scanname.barcodes
		    zbarimg -q $scan >> $barcode_folder/$scanname.barcodes
		    echo "Done."
	    fi
	
    popd > /dev/null
fi

