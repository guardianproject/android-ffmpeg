#!/bin/bash
pushd `dirname $0`
. settings.sh

pushd freetype2

./autogen.sh

./configure \
    CC="$CC" \
    LD="$LD" \
    CFLAGS="-std=gnu99 -mcpu=cortex-a8 -marm -mfloat-abi=softfp -mfpu=neon" \
    --host=$HOST \
    --with-sysroot="$NDK_SYSROOT" \
    --enable-static \
    --disable-shared \
    --without-bzip2

popd;popd
