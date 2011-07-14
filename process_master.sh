#!/bin/bash

idname="Participant ID"
default="05-XXXXX-X"
last_id=`cat ~/.last_scan_id`

install_base=`dirname "$0"`

echo $install_base

pushd "${install_base}" > /dev/null

identifier=`zenity --entry \
	--title="Process Master Chart for ${idname}" \
	--text="Please Enter the ${idname}" \
	--entry-text="${last_id}"`

if [ "${identifier}" == "${default}" ]; then
	zenity --warning \
	--title="Process Master Chart for ${idname}" \
	--text="Sorry, but ${identifier} is not a valid ${idname}."
elif [ "${identifier}" != "" ]; then
	echo "Getting ready to process scans for ${idname}: ${identifier}"
	./image_process_folder.sh ~/Scans/${identifier}_master
fi

popd > /dev/null
