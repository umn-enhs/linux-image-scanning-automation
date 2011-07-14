#!/bin/bash

sudo apt-get install -y \
	zenity \
	xsane \
	imagemagick \
	graphicsmagick
	libtiff-tools \
	tesseract-ocr \
	ocrad \
	gocr \
	zbar-tools \
	libnetpbm10-dev \
	libtiff4-dev

echo "You'll also need to install Page Tools"
echo "	Available at: http://pagetools.sourceforge.net/"

pagetools=~/Downloads/pagetools-0.1.tar.gz

if [ -e $pagetools ]; then
	mkdir ~/Downloads/pagetools
	pushd ~/Downloads/pagetools
	
	tar -xvzf $pagetools
	make
	sudo cp tiff_findskew/tiff_findskew /usr/bin/
	sudo cp pbm_findskew/pbm_findskew /usr/bin/
	
	popd
else
	echo "$pagetools not found, not installing."

fi
