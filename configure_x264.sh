#!/bin/bash
pushd `dirname $0`
. settings.sh

pushd x264

./configure --cross-prefix=arm-linux-androideabi- \
--enable-pic \
--host=arm-linux 

popd;popd
