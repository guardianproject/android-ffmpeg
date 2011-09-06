#!/bin/bash
pushd `dirname $0`
. settings.sh

if [[ $DEBUG == 1 ]]; then
  echo "DEBUG = 1"
  DEBUG_FLAG="--disable-stripping"
fi

pushd ffmpeg

./configure $DEBUG_FLAG --enable-cross-compile \
--arch=arm5te \
--enable-armv5te \
--target-os=linux \
--disable-stripping \
--prefix=../output \
--enable-pic \
--disable-shared \
--enable-static \
--enable-cross-compile \
--cross-prefix=$NDK_TOOLCHAIN_BASE/bin/arm-linux-androideabi- \
--sysroot="$NDK_SYSROOT" \
--extra-cflags="-I../x264" \
--extra-ldflags="-L../x264" \
--enable-version3 \
--enable-gpl \
--enable-memalign-hack \
--disable-doc \
--enable-yasm \
--disable-everything \
--enable-decoder=mjpeg \
--enable-demuxer=mjpeg \
--enable-parser=mjpeg \
--enable-demuxer=image2 \
--enable-muxer=mp4 \
--enable-encoder=libx264 \
--enable-libx264 \
--enable-decoder=rawvideo \
--enable-protocol=file \
--enable-hwaccels \
--enable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-network \
--enable-filter=buffer \
--enable-filter=buffersink \
--disable-demuxer=v4l \
--disable-demuxer=v4l2 \
--disable-indev=v4l \
--disable-indev=v4l2

popd; popd
