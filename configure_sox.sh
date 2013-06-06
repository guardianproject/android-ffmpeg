#!/bin/bash
pushd `dirname $0`
. settings.sh

if [[ $DEBUG == 1 ]]; then
  echo "DEBUG = 1"
  DEBUG_FLAG="--disable-stripping"
fi

pushd sox
patch -N -p1 --reject-file=- < ../sox-update-ffmpeg-api.patch
autoreconf -i

PKG_CONFIG=../fake-pkg-config
PKG_CONFIG_LIBDIR="$LOCAL/lib/pkgconfig"
FFMPEG_LDFLAGS="-L$LOCAL/lib -L$DESTDIR/x264"
FFMPEG_LIBS="-lavformat -lavcodec -lavutil -lz -lx264"
FFMPEG_CFLAGS="-I$LOCAL/include"
export PKG_CONFIG
export PKG_CONFIG_LIBDIR
export FFMPEG_CFLAGS
export FFMPEG_LIBS
./configure \
        CC="$CC" \
        LD="$LD" \
        STRIP="$STRIP" \
        --host=$HOST \
        --with-sysroot="$NDK_SYSROOT" \
        --enable-static \
        --disable-shared \
        --with-ffmpeg \
        --without-libltdl


popd; popd


