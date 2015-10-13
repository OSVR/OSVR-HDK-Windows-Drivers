#!/bin/sh -e
# Generate device-metadata-package-suitable icon from source image(s)
#
# Copyright 2015 Sensics, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# 	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

rm -rf output
mkdir -p output/256
mkdir -p output/16
bigsrc=input/ircamera.png
smallsrc=input/ircamera.png
outname=HDK-IR-Camera.ico

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

    convert *.png 256/* 16/*  $outname
)
