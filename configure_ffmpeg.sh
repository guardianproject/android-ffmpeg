#!/bin/bash
pushd `dirname $0`
. settings.sh

if [[ $DEBUG == 1 ]]; then
  echo "DEBUG = 1"
  DEBUG_FLAG="--disable-stripping"
fi

pushd ffmpeg

# apply patch to get 'redact' filter
test -e libavfilter/vf_redact.c || \
    patch -p1 < ../0001-add-filter-to-redact-regions-configured-by-a-text-fi.patch

# build fix
patch -p1 -N --reject-file=- <  ../swscale-fix.diff

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
--arch=arm \
--cpu=cortex-a8 \
--target-os=linux \
--enable-runtime-cpudetect \
--prefix=/data/data/org.witness.sscvideoproto \
--enable-pic \
--disable-shared \
--enable-static \
--enable-small \
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
--enable-zlib \
--extra-cflags="-I../x264" \
--extra-ldflags="-L../x264" \
--disable-avdevice \
--disable-devices

popd; popd

# for NEON, but it apparently doesn't help (yet)
#--cpu=cortex-a8 \
#--enable-neon \
#--extra-cflags="-mfloat-abi=softfp -mfpu=neon -I../x264" \


