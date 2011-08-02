#!/bin/bash



pagetools=~/Downloads/pagetools-0.1.tar.gz

if [ -e $pagetools ]; then

	sudo apt-get install -y \
		zenity \
		xsane \
		imagemagick \
		graphicsmagick \
		libtiff-tools \
		tesseract-ocr \
		ocrad \
		gocr \
		zbar-tools \
		libnetpbm10-dev \
		libtiff4-dev 

	if [ ! -e /usr/bin/tiff_findskew ] || [ ! -e /usr/bin/pbm_findskew ]; then
		mkdir ~/Downloads/pagetools
		pushd ~/Downloads/pagetools
	
		tar -xvzf $pagetools
		make
		sudo cp tiff_findskew/tiff_findskew /usr/bin/
		sudo cp pbm_findskew/pbm_findskew /usr/bin/
		popd
	fi
	

	echo "installing desktop shortcuts..."
	cp shortcuts/*.desktop ~/Desktop/

	
	if [ ! -d /var/lib/scans ]; then
		echo "Creating /var/lib/scans..."
		sudo mkdir /var/lib/scans
	fi

	if [ -d /var/lib/scans ] && [ ! -h ~/Scans ]; then
		echo "Symlinking Scans Folder..."
		ln -s /var/lib/scans ~/Scans
	fi

else
	echo "You'll need to download Page Tools"
	echo "	Available at: http://pagetools.sourceforge.net/"

	echo "$pagetools not found, not installing."

fi

