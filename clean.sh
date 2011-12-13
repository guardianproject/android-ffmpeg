#!/bin/bash
pushd `dirname $0`
. settings.sh

find . -name \*.o -delete

pushd x264
make clean

popd
pushd ffmpeg
make clean

popd
