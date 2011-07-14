#!/bin/bash

participant_id="$1"
today=`date +%Y-%m-%d`
device="fujitsu:fi-6240dj:5826"

if [ "${participant_id}" != "" ]; then

	if [ ! -d ~/Scans ]; then
		mkdir ~/Scans
	fi

	if [ ! -d ~/Scans/${participant_id} ]; then
		mkdir ~/Scans/${participant_id}
	fi

	filebase="${participant_id}_${today}"

	pushd ~/Scans/${participant_id} > /dev/null

	scanimage --device-name="$device" \
		--format=tiff \
		--batch=$filebase_%d.tif \
		--batch-increment=1 \
		--progress \
		--resolution=600dpi \
		--source="ADF Duplex" \
		--mode="Lineart"
		
	popd > /dev/null
fi
