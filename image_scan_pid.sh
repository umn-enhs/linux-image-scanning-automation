#!/bin/bash

participant_id="$1"
today=`date +%Y-%m-%d`
device="fujitsu:fi-6240dj:5826"
source="ADF Duplex"
dpi=300

if [ "$2" == "flatbed" ]; then
	source="Flatbed"
fi

if [ "${participant_id}" != "" ]; then

	if [ ! -d ~/Scans ]; then
		mkdir ~/Scans
	fi

	if [ ! -d ~/Scans/${participant_id} ]; then
		mkdir ~/Scans/${participant_id}
	fi

	filebase="${participant_id}_${today}"

	pushd ~/Scans/${participant_id} > /dev/null

	lastscan=$(ls | sed -e 's/.tif//' | sort -n | tail -n 1 )
	
	if [ "$lastscan" == "" ]; then
		nextnum=1
	else
		nextnum=$(($lastscan + 1))
	fi

	zenity --warning \
		--text="Last Scan: ${lastscan}, starting scan: ${nextnum}."

	scanimage --device-name="$device" \
		--format=tiff \
		--batch=$filebase_%d.tif \
		--batch-increment=1 \
		--batch-start $nextnum \
		--progress \
		--resolution=${dpi}dpi \
		--source="${source}" \
		--mode="Lineart"
	
	file_size=$(stat -c%s $nextnum.tif)
	
	echo $file_size > ~/.last_scan_size
	
	
	popd > /dev/null
fi
