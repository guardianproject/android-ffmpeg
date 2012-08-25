#!/bin/bash
pushd `dirname $0`
. settings.sh
pushd freetype2
make -j4
popd;popd
