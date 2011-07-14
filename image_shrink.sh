#!/bin/bash

scan="$1"
temptif=`mktemp /tmp/temp-XXXXXXXX`
rm -f $temptif
temptif="$temptif.tif"

# Resizes scans for permanent storage
if [ -f "$scan" ]; then
	
	compression=`tiffinfo "${scan}" | grep "Compression Scheme" | awk -F ": " '{print $2}'` 
	
	if [ "${compression}" != "LZW" ]; then
        
        mogrify -compress lzw "${scan}"
	fi
fi

