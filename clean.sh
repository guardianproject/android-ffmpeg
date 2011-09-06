#!/bin/sh
pushd `dirname $0`
. settings.sh

pushd x264
make clean

popd
pushd ffmpeg
make clean

popd
