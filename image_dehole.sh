#!/bin/bash

# Removes hole-punch marks and 0.25" border from page

scan="$1"

dpi=`tiffinfo "${scan}" | grep "Resolution:" | sed -e 's/  Resolution: //'| awk -F "," '{print $1}'` 

left=$(( $dpi / 60 * 25 ))
right=$(( $dpi / 60 * 483 ))
upper=$(( $dpi / 60 * 249 ))
lower=$(( $dpi / 60 * 415 ))
radius=$(( $dpi / 60 * 12 ))

shave=$(( $dpi / 4 ))

right_top="${right},${upper} $((right+radius)),$((upper+radius))"
right_bottom="${right},${lower} $((right+radius)),$((lower+radius))"
left_top="${left},${upper} $((left+radius)),$((upper+radius))"
left_bottom="${left},${lower} $((left+radius)),$((lower+radius))"

mogrify -fill white \
	-draw "circle $right_top" \
	-draw "circle $right_bottom" \
	-draw "circle $left_top" \
	-draw "circle $left_bottom" \
	-shave ${shave}x${shave} \
	-type BiLevel \
	$scan

