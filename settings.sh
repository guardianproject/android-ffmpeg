#!/bin/bash

# set to path of your NDK (or export NDK to environment)

if [[ "x$NDK" == "x" ]]; then
NDK=~/apps/android-ndk-r5c
fi
# i use only a small number of formats - set this to 0 if you want everything.
# changed 0 to the default, so it'll compile shitloads of codecs normally
if [[ "x$minimal_featureset" == "x" ]]; then
minimal_featureset=1
fi

## stop editing

if [[ ! -d $NDK ]]; then
  echo "$NDK is not a directory. Exiting."
  exit 1
fi

function current_dir {
  echo "$(cd "$(dirname $0)"; pwd)"
}

export PATH=$PATH:$NDK:$(current_dir)/toolchain/bin

echo $PATH

