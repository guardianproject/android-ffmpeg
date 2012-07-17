#!/bin/bash
pushd `dirname $0`
. settings.sh

if [[ $DEBUG == 1 ]]; then
  echo "DEBUG = 1"
  DEBUG_FLAG="--disable-stripping"
fi

# I haven't found a reliable way to install/uninstall a patch from a Makefile,
# so just always try to apply it, and ignore it if it fails. Works fine unless
# the files being patched have changed, in which cause a partial application
# could happen unnoticed.
patch -N -p1 --reject-file=- < redact-plugins.patch

pushd ffmpeg

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


