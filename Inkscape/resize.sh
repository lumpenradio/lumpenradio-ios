#!/bin/bash

INK=/Applications/Inkscape.app/Contents/MacOS/inkscape

if [[ -z "$1" ]] 
then
	echo "SVG file needed."
	exit;
fi

#BASE=`basename "$1" .svg`
BASE=`basename "$1" .svg`
SVG="$1"

# iPhone Spotlight iOS5,6 Settings iOS and iPad 5-8 29pt
#$INK -z -D -o "$BASE-29.png" --export-width=29 	$SVG -w 29 -h 29
#$INK -z -D -o "$BASE-29.png" -p $SVG -w 29 -h 29
#
#$INK -z -D -o "$BASE-29@2x.png" -p 	$SVG -w 58 -h 58
#$INK -z -D -o "$BASE-29@3x.png" -p      $SVG -w 87 -h 87
#
## iPhone Spotlight iOS7,8 40pt
#$INK -z -D -o "$BASE-40@2x.png" -p 	$SVG -w 80 -h 80
#$INK -z -D -o "$BASE-40@3x.png" -p      $SVG -w 120 -h 120
#
## iPhone App iOS 5,6 57pt
#$INK -z -D -o "$BASE-57.png" -p 	$SVG -w 57 -h 57
#$INK -z -D -o "$BASE-57@2x.png" -p 	$SVG -w 114 -h 114
#
## iPhone App iOS 7,8 60pt
#$INK -z -D -o "$BASE-60@2x.png" -p 	$SVG -w 120 -h 120
#$INK -z -D -o "$BASE-60@3x.png" -p      $SVG -w 180 -h 180
#
## iPad Spotlight iOS 7 40pt
#$INK -z -D -o "$BASE-40.png" -p 	$SVG -w 40 -h 40
#
## iPad Spotlight iOS 5,6 50pt
#$INK -z -D -o "$BASE-50.png" -p 	$SVG -w 50 -h 50
#$INK -z -D -o "$BASE-50@2x.png" -p 	$SVG -w 100 -h 100
#
## iPad App iOS 5,6 72pt
#$INK -z -D -o "$BASE-72.png" -p 	$SVG -w 72 -h 72
#$INK -z -D -o "$BASE-72@2x.png" -p 	$SVG -w 144 -h 144
#
## iPad App iOS 7  76pt
#$INK -z -D -o "$BASE-76.png" -p 	$SVG -w 76 -h 76 
#$INK -z -D -o "$BASE-76@2x.png" -p 	$SVG -w 152 -h 152
#
##iTunes Artwork
#$INK -z -D -o "$BASE-512.png" -p 	$SVG -w 512 -h 512
#$INK -z -D -o "$BASE-1024.png" -p 	$SVG -w 1024 -h 1024

$INK -z -D -o "lumpenRadioAppIcon.png" -p 	$SVG -w 1536 -h 1536

#cp "$BASE-512.png" iTunesArtwork.png
#cp "$BASE-1024.png" iTunesArtwork@2x.png
