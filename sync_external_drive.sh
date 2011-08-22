#!/bin/bash

echo "Searching for external drives..."
devices=`mktemp /tmp/external-drives.XXXXXXXXXXX`

mount -t fuseblk \
	| sed -e 's/\/dev\/sd[a-z0-9]* on //' \
	| sed -e 's/ type fuseblk .*//' \
	> $devices


while read device; do

	echo "Found: '$device'"
	flagfile="$device/nlst-imaging.flag"
	if [ -f "$flagfile" ]; then
		echo "Flag file: $flagfile, found.  Syncing with device: $device."
		syncfolder="$device/nlst-scans"
		if [ ! -d "$syncfolder" ]; then
			mkdir "$syncfolder"
		fi
		
		if [ -d "$device/nlst-scans" ]; then
			rsync -rvt /var/lib/scans/ "$device/nlst-scans/"
		else
			echo "Unable to create sync folder! [$syncfolder]"
		fi
		
	else
		echo "Flag file: $flagfile, not found.  Skipping device: $device."
	fi
	
done < "$devices"
rm -f $devices

zenity --info --text="Finished syncing with external drive.\nPlease, now right click on the drive and choose 'Safely Remove'." &
