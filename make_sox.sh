#!/bin/bash
pushd `dirname $0`
. settings.sh
pushd sox
make -j4
make DESTDIR=$DESTDIR prefix=$prefix install
popd; popd
