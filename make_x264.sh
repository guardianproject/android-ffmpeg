#!/bin/bash
pushd `dirname $0`
. settings.sh
pushd x264
make
popd;popd
