#!/bin/bash
pushd `dirname $0`
. settings.sh

if [[ $DEBUG == 1 ]]; then
  echo "DEBUG = 1"
  DEBUG_FLAG="--disable-stripping"
fi

pushd sox
git apply ../sox-update-ffmpeg-api.patch
autoreconf -i

PKG_CONFIG=../fake-pkg-config
PKG_CONFIG_LIBDIR="$LOCAL/lib/pkgconfig"
FFMPEG_LIBS="-L$LOCAL/lib -lavformat -lavcodec -lavutil -lz -L$DESTDIR/x264 -lx264"
FFMPEG_CFLAGS="-I$LOCAL/include"
export PKG_CONFIG
export PKG_CONFIG_LIBDIR
export FFMPEG_CFLAGS
export FFMPEG_LIBS
./configure \
        CC="$CC" \
        LD="$LD" \
        --host=$HOST \
        --with-sysroot="$NDK_SYSROOT" \
        --enable-static \
        --disable-shared \
        --with-ffmpeg \
        --without-libltdl \
        --without-bzip2


popd; popd


