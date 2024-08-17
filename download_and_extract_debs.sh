#!/bin/bash

#DEBUG=1

## ARG 1, "$SDK_NAME-$VERSION/", ARG 2 --no-color

# Allow disabling colored output for CI etc
if [[ "$2" = "--no-color" ]]; then
  export NO_COLOR=1
fi

source messages.sh

TOOLCHAIN_PATH="$1/"
TRIPLET=aarch64-linux-gnu

mkdir $TOOLCHAIN_PATH/$TRIPLET/docs

cat package_list.txt | while read pkg; do
  DEB_NAME=$(basename $pkg)
  inform "Fetching $DEB_NAME"
  if [[ $DEBUG == 1 ]]; then
    wget $pkg
  else
    wget -q --show-progress $pkg
  fi
  ret=$?
  if [ $ret -ne 0 ]; then
    exit 1
  fi
  run_cmd ar vx $DEB_NAME
  ret=$?
  if [ $ret -ne 0 ]; then
    exit 2
  fi
  if [ -f data.tar.gz ]; then
    tar -xf data.tar.gz
  elif [ -f data.tar.xz ]; then
    tar -xf data.tar.xz
  elif [ -f data.tar.zst ]; then
    tar -xf data.tar.zst
  else
    error "ERROR: can't find data.tar.*"
    exit 3
  fi 
  ret=$?
  if [ $ret -ne 0 ]; then
    exit 4
  fi
  if [ -d "usr/include" ]; then
    cp -r usr/include/* $TOOLCHAIN_PATH/$TRIPLET/include/
  fi

  cp -r usr/lib/$TRIPLET/* $TOOLCHAIN_PATH/$TRIPLET/lib/
  if [ -d "lib/" ]; then
    cp -r lib/$TRIPLET/* $TOOLCHAIN_PATH/$TRIPLET/lib/
  fi
  # Copy license info if it exists.
  if [ -d "usr/share" ]; then
    cp -r usr/share/* $TOOLCHAIN_PATH/$TRIPLET/docs/
  fi
  rm -rf usr/ lib/ etc/ bin/ data.tar.*z control.tar.*z control.tar.zst data.tar.zst debian-binary
done

cp -r $TOOLCHAIN_PATH/$TRIPLET/include/$TRIPLET/* $TOOLCHAIN_PATH/$TRIPLET/include/

# dbus gets linked to /lib
pushd $TOOLCHAIN_PATH/$TRIPLET/lib/
#unlink libdbus-1.so
#ln -s libdbus-1.so.3.19.4 libdbus-1.so
#unlink libbsd.so
#ln -s libbsd.so.0.8.7 libbsd.so
popd

rm *arm64.deb all.deb
