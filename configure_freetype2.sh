#!/bin/bash
pushd `dirname $0`
. settings.sh

pushd freetype2

case $TARGET_ARCH in
  x86)
  ;;
  arm)
  EXTRA_CFLAGS="$EXTRA_CFLAGS -mcpu=cortex-a8 -marm -mfloat-abi=softfp -mfpu=neon"
  ;;
esac

./autogen.sh

./configure \
    CC="$CC" \
    LD="$LD" \
    CFLAGS="-std=gnu99 -fPIE -pie $EXTRA_CFLAGS" \
    --host=$HOST \
    --with-sysroot="$NDK_SYSROOT" \
    --enable-static \
    --disable-shared \
    --with-pic \
    --without-bzip2

popd;popd
