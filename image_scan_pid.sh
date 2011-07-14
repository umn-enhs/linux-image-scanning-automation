#!/bin/bash

participant_id="$1"
today=`date +%Y-%m-%d`
device="fujitsu:fi-6240dj:5826"
source="ADF Duplex"

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

	lastscan=$(ls | sort | tail -n 1)
	if [ "$lastscan" == "" ]; then
		nextnum=1
	else
		lastnum=$(basename $lastscan .tif)
		nextnum=$(($lastnum + 1))
	fi

	scanimage --device-name="$device" \
		--format=tiff \
		--batch=$filebase_%d.tif \
		--batch-increment=1 \
		--batch-start $nextnum \
		--progress \
		--resolution=600dpi \
		--source="${source}" \
		--mode="Lineart"
		
	popd > /dev/null
fi
