#!/bin/bash
pushd `dirname $0`
. settings.sh
pushd sox
make -j4
make STRIP=$STRIP DESTDIR=$DESTDIR prefix=$prefix install-strip
popd; popd
