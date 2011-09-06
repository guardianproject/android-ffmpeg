#!/bin/bash
pushd `dirname $0`
. settings.sh

pushd x264

./configure --cross-prefix=$NDK_TOOLCHAIN_BASE/bin/arm-linux-androideabi- \
--sysroot="$NDK_SYSROOT" \
--host=arm-linux \
--enable-pic \
--enable-static \
--disable-cli

popd;popd
