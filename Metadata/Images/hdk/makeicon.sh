#!/bin/sh
rm -rf output
mkdir -p output/256
mkdir -p output/16
bigsrc=input/angled-square.png
smallsrc=input/straighton-square.png

makeimg() {
    infile=$1
    size=$2
    convert $infile -resize ${size}x${size} output/${size}.png
}

makeimg $bigsrc 256
makeimg $smallsrc 48
makeimg $smallsrc 32
makeimg $smallsrc 24
makeimg $smallsrc 16
(
    cd output
    for fn in 48.png 32.png 24.png 16.png; do
        convert $fn -channel A -threshold 75% +channel -background hotpink -alpha background  256/$fn.gif
        convert $fn -channel A -threshold 75% +channel -background hotpink -alpha background  -colors 16 16/$fn.gif
    done

    convert *.png 256/* 16/*  HDK.ico
)