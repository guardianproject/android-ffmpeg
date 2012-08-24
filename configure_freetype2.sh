#!/bin/bash
pushd `dirname $0`
. settings.sh

pushd freetype2

./autogen.sh

./configure \
    CC="$CC" \
    LD="$LD" \
    --host=$HOST \
    --with-sysroot="$NDK_SYSROOT" \
    --enable-static \
    --without-bzip2

popd;popd
