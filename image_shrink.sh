#!/bin/bash

scan="$1"
temptif=`mktemp /tmp/temp-XXXXXXXX`
rm -f $temptif
temptif="$temptif.tif"

# Resizes scans for permanent storage
if [ -f "$scan" ]; then

	# If it's too big, shrink it
	file_size=$(stat -c%s $scan)
	if ((( $file_size > 1000000 ))); then
		compression=`tiffinfo "${scan}" | grep "Compression Scheme" | awk -F ": " '{print $2}'` 
	
		if [ "${compression}" != "LZW" ]; then
		    
		    nice mogrify -compress lzw "${scan}"
		fi
	fi
fi

