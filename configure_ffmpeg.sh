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
patch -N -p1 --reject-file=- < arm-asm-fix.patch

pushd ffmpeg

./configure \
$DEBUG_FLAG \
--arch=arm \
--cpu=cortex-a8 \
--target-os=linux \
--enable-runtime-cpudetect \
--prefix=/data/data/org.witness.sscvideoproto \
--enable-pic \
--disable-shared \
--enable-static \
--enable-small \
--cross-prefix=$NDK_TOOLCHAIN_BASE/bin/$NDK_ABI-linux-androideabi- \
--sysroot="$NDK_SYSROOT" \
--extra-cflags="-I../x264 -mfloat-abi=softfp -mfpu=neon" \
--extra-ldflags="-L../x264" \
\
--enable-version3 \
--enable-gpl \
\
--enable-memalign-hack \
--disable-doc \
--enable-yasm \
\
--disable-decoders \
--enable-decoder=aac \
--enable-decoder=amrnb \
--enable-decoder=amrwb \
--enable-decoder=h264 \
--enable-decoder=mjpeg \
--enable-decoder=rawvideo \
\
--disable-encoders \
--enable-encoder=aac \
--enable-encoder=libx264 \
--enable-encoder=mpeg2video \
--enable-encoder=mpeg4 \
--enable-encoder=pcm_f32le \
--enable-encoder=pcm_s16le \
--enable-encoder=pcm_u16le \
\
--disable-muxers \
--enable-muxer=mp4 \
--enable-muxer=matroska \
--enable-muxer=matroska_audio \
--enable-muxer=mpeg2video \
--enable-muxer=mpegts \
--enable-muxer=yuv4mpegpipe \
\
--disable-demuxers \
--enable-demuxer=aac \
--enable-demuxer=amr \
--enable-demuxer=image2 \
--enable-demuxer=mjpeg \
--enable-demuxer=mp3 \
--enable-demuxer=mp4 \
--enable-demuxer=mov \
--enable-demuxer=wav \
\
--disable-parsers \
--enable-parser=aac \
--enable-parser=aac_latm \
--enable-parser=h264 \
--enable-parser=mjpeg \
--enable-parser=mpeg4video \
--enable-parser=mpegaudio \
--enable-parser=mpegvideo \
\
--disable-protocols \
--enable-protocol=cache \
--enable-protocol=concat \
--enable-protocol=file \
--enable-protocol=md5 \
--enable-protocol=pipe \
\
--disable-filters \
--enable-filter=amerge \
--enable-filter=amix \
--enable-filter=aredact \
--enable-filter=aresample \
--enable-filter=volume \
--enable-filter=buffersink \
--enable-filter=drawbox \
--enable-filter=overlay \
--enable-filter=redact \
\
--disable-bsfs \
\
--disable-indevs \
--enable-indev=lavfi \
--disable-outdevs \
\
--enable-hwaccels \
\
--enable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-network \
\
--enable-libx264 \
--enable-zlib

popd; popd


