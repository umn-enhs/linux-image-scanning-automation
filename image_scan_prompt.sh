#!/bin/bash

idname="Participant ID"
default="05-XXXXX-X"


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
else
	echo "Getting ready to scan for ${idname}: ${identifier}"
	nautilus ~/Scans/${identifier}/
	./image_scan_pid.sh ${identifier}
fi

popd > /dev/null
