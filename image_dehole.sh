#!/bin/bash

# Removes hole-punch marks and 0.25" border from page

scan="$1"

left=250
right=4830
upper=2490
lower=4150
radius=120

center_left
center_right
right_top="${right},${upper} $((right+radius)),$((upper+radius))"
right_bottom="${right},${lower} $((right+radius)),$((lower+radius))"
left_top="${left},${upper} $((left+radius)),$((upper+radius))"
left_bottom="${left},${lower} $((left+radius)),$((lower+radius))"

mogrify -fill white \
	-draw "circle $right_top" \
	-draw "circle $right_bottom" \
	-draw "circle $left_top" \
	-draw "circle $left_bottom" \
	-shave 150x150 \
	-type BiLevel \
	$scan

