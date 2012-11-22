#!/bin/bash

# set the base path to your Android NDK (or export NDK to environment)

if [[ "x$NDK_BASE" == "x" ]]; then
    NDK_BASE=/opt/android-ndk
    echo "No NDK_BASE set, using $NDK_BASE"
fi

NDK_PLATFORM_VERSION=3
NDK_ABI=arm
NDK_COMPILER_VERSION=4.6
NDK_SYSROOT=$NDK_BASE/platforms/android-$NDK_PLATFORM_VERSION/arch-$NDK_ABI
NDK_UNAME=`uname -s | tr '[A-Z]' '[a-z]'`
HOST=$NDK_ABI-linux-androideabi
NDK_TOOLCHAIN_BASE=$NDK_BASE/toolchains/$HOST-$NDK_COMPILER_VERSION/prebuilt/$NDK_UNAME-x86
STRIP=$NDK_TOOLCHAIN_BASE/bin/$NDK_ABI-linux-androideabi-strip
CC="$NDK_TOOLCHAIN_BASE/bin/$HOST-gcc --sysroot=$NDK_SYSROOT"
LD=$NDK_TOOLCHAIN_BASE/bin/$HOST-ld

# i use only a small number of formats - set this to 0 if you want everything.
# changed 0 to the default, so it'll compile shitloads of codecs normally
if [[ "x$minimal_featureset" == "x" ]]; then
minimal_featureset=1
fi

function current_dir {
  echo "$(cd "$(dirname $0)"; pwd)"
}

CWD=`pwd`
PROJECT_ROOT=$CWD
EXTERNAL_ROOT=$PROJECT_ROOT

# install root for built files
DESTDIR=$EXTERNAL_ROOT
prefix=/data/data/info.guardianproject.ffmpeg/app_opt
LOCAL=$DESTDIR$prefix


