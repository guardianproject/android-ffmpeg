#!/bin/bash
pushd `dirname $0`
. settings.sh

if [[ $DEBUG == 1 ]]; then
  echo "DEBUG = 1"
  DEBUG_FLAG="--disable-stripping"
fi

pushd ffmpeg

# apply patch to get 'redact' filter
test -e ffmpeg/libavfilter/vf_redact.c || \
    patch -p1 < ../0001-add-filter-to-redact-regions-configured-by-a-text-fi.patch


#--disable-decoders \
#--disable-encoders \
#--disable-muxers \
#--disable-demuxers \
#--disable-parsers \
#--disable-filters \
#--disable-protocols \

./configure \
$DEBUG_FLAG \
--enable-cross-compile \
--arch=armv5te \
--cpu=armv5te \
--target-os=linux \
--enable-runtime-cpudetect \
--prefix=/data/data/org.witness.sscvideoproto \
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
--enable-decoder=mjpeg \
--enable-decoder=rawvideo \
\
--enable-encoder=libx264 \
\
--enable-muxer=mp4 \
\
--enable-demuxer=image2 \
--enable-demuxer=mjpeg \
--enable-demuxer=mp4 \
--enable-demuxer=mov \
\
--enable-parser=mjpeg \
\
--enable-filter=buffer \
--enable-filter=buffersink \
--enable-filter=drawbox \
--enable-filter=overlay \
--enable-filter=redact \
\
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
--disable-avdevice \
--disable-indev=v4l \
--disable-indev=v4l2

popd; popd
