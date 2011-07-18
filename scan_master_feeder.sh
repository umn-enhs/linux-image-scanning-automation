#!/bin/bash

idname="Participant ID"
default="05-XXXXX-X"
last_id=`cat ~/.last_scan_id`

install_base=`dirname "$0"`

echo $install_base

pushd "${install_base}" > /dev/null

identifier=`zenity --entry \
	--title="Scan for ${idname}" \
	--text="Please Enter the ${idname}" \
	--entry-text="${default}"`

if [ "${identifier}" == "${default}" ]; then
	zenity --warning \
	--title="Scan for ${idname}" \
	--text="Sorry, but ${identifier} is not a valid ${idname}."
elif [ "${identifier}" != "" ]; then
	echo "Getting ready to scan for ${idname}: ${identifier}"

	echo ${identifier} > ~/.last_scan_id

	mkdir -p ~/Scans/${identifier}_master/
		
	nautilus ~/Scans/${identifier}_master/
	./image_scan_pid.sh ${identifier}_master
fi

popd > /dev/null
