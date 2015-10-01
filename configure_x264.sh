#!/bin/bash
pushd `dirname $0`
. settings.sh

pushd x264

case $NDK_ABI in
  x86)
  TARGET_HOST=i686-linux
  ;;
  arm)
  TARGET_HOST=arm-linux
  ;;
esac

./configure --cross-prefix=$NDK_TOOLCHAIN_BASE/bin/$HOST- \
--sysroot="$NDK_SYSROOT" \
--host=$TARGET_HOST \
--enable-pic \
--enable-static \
--extra-cflags="-fPIE -pie" \
--extra-ldflags="-fPIE -pie" \
--disable-cli \
--disable-opencl 

popd;popd
