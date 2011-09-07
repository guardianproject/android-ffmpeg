#!/bin/bash
pushd `dirname $0`
. settings.sh

if [[ $DEBUG == 1 ]]; then
  echo "DEBUG = 1"
  DEBUG_FLAG="--disable-stripping"
fi

pushd ffmpeg

# apply patch to get 'redact' filter
test ffmpeg/libavfilter/vf_redact.c || \
    patch -p1 < ../0001-add-filter-to-redact-regions-configured-by-a-text-fi.patch

./configure \
$DEBUG_FLAG \
--enable-cross-compile \
--arch=armv5te \
--cpu=armv5te \
--target-os=linux \
--enable-runtime-cpudetect \
--prefix=../output \
--enable-pic \
--disable-shared \
--enable-static \
--cross-prefix=$NDK_TOOLCHAIN_BASE/bin/arm-linux-androideabi- \
--sysroot="$NDK_SYSROOT" \
--enable-version3 \
--enable-gpl \
--enable-memalign-hack \
--disable-doc \
--enable-yasm \
\
--disable-decoders \
--enable-decoder=mjpeg \
--enable-decoder=rawvideo \
\
--disable-encoders \
--enable-encoder=libx264 \
\
--disable-muxers \
--enable-muxer=mp4 \
\
--disable-demuxers \
--enable-demuxer=image2 \
--enable-demuxer=mjpeg \
--enable-demuxer=mp4 \
--enable-demuxer=mov \
\
--disable-parsers \
--enable-parser=mjpeg \
\
--disable-filters \
--enable-filter=buffer \
--enable-filter=buffersink \
--enable-filter=drawbox \
--enable-filter=overlay \
--enable-filter=redact \
\
--disable-protocols \
--enable-protocol=file \
\
--enable-hwaccels \
\
--enable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-network \
--enable-libx264 \
--extra-cflags="-I../x264" \
--extra-ldflags="-L../x264" \
--disable-indev=v4l \
--disable-indev=v4l2

popd; popd
