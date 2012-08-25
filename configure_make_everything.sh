#!/bin/bash

function die {
  echo "$1 failed" && exit 1
}

./clean.sh
./configure_x264.sh || die "X264 configure"
./make_x264.sh || die "X264 make"
./configure_freetype2.sh || die "freetype2 configure"
./make_freetype2.sh || die "freetype2 make"
./configure_ffmpeg.sh || die "FFMPEG configure"
./make_ffmpeg.sh || die "FFMPEG make"
