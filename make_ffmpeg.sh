#!/bin/bash
pushd `dirname $0`
. settings.sh
pushd ffmpeg
make
popd; popd
