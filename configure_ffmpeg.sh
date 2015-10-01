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
patch -d ffmpeg -N -p1 --reject-file=- < \
    ARM_generate_position_independent_code_to_access_data_symbols.patch
patch -d ffmpeg -N -p1 --reject-file=- < \
    ARM_intmath_use_native-size_return_types_for_clipping_functions.patch
patch -d ffmpeg -N -p1 --reject-file=- < \
    enable-fake-pkg-config.patch

pushd ffmpeg

if [[ $NDK_ABI == "arm" ]]; then
  EXTRA_CFLAGS="$EXTRA_CFLAGS -mfloat-abi=softfp -mfpu=neon"
fi

if [[ $NDK_ABI == "x86" ]]; then
  EXTRA_CFLAGS="$EXTRA_CFLAGS -mtune=atom -mssse3 -mfpmath=sse"
  NDK_TOOLCHAIN_BASE=$NDK_BASE/toolchains/x86-4.8/prebuilt/$NDK_UNAME-$NDK_PROCESSOR #force gcc 4.8 because of http://www.ffmpeg.org/faq.html#error_003a-can_0027t-find-a-register-in-class-_0027GENERAL_005fREGS_0027-while-reloading-_0027asm_0027
fi


./configure \
$DEBUG_FLAG \
--arch=$NDK_ABI \
--cpu=$TARGET_CPU \
--target-os=linux \
--enable-cross-compile \
--prefix=$prefix \
--enable-pic \
--disable-shared \
--enable-static \
--cross-prefix=$NDK_TOOLCHAIN_BASE/bin/$HOST- \
--sysroot="$NDK_SYSROOT" \
--extra-cflags="-I../x264 -fPIE -pie $EXTRA_CFLAGS" \
--extra-ldflags="-L../x264 -fPIE -pie" \
\
--enable-version3 \
--enable-gpl \
\
--disable-doc \
--disable-avx \
--enable-yasm \
\
--enable-decoders \
--enable-encoders \
--enable-muxers \
--enable-demuxers \
--enable-parsers \
--enable-protocols \
--enable-filters \
--enable-avresample \
--enable-libfreetype \
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
--enable-zlib \
--enable-muxer=md5

popd; popd


