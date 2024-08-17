#!/bin/bash

VERSION="0.1.0"
SDK_NAME="rg35xx-plus-aarch64-SDL2-SDK"
# Allow disabling colored output for CI etc
if [[ "$1" = "--no-color" ]]; then
  export NO_COLOR=1
fi

source messages.sh

inform "Fetching arm compiler and toolchain"
# Fetch toolchain from arm
wget -q --show-progress https://developer.arm.com/-/media/Files/downloads/gnu/11.3.rel1/binrel/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz

inform "Extracting Compiler"
tar -xf arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz

inform "Setting up filesystem"
mv arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu "$SDK_NAME-$VERSION"
pushd "$SDK_NAME-$VERSION/"
mv aarch64-none-linux-gnu/ aarch64-linux-gnu/

# Ubuntu uses lib rather then lib64
mv aarch64-linux-gnu/lib64/* aarch64-linux-gnu/lib

# Copy back for compat
ln -s aarch64-linux-gnu/ aarch64-none-linux-gnu
popd

# Copy in the SDL Libs and headers
cp SDL2/lib/* "$SDK_NAME-$VERSION/aarch64-linux-gnu/lib/"
cp -r SDL2/include/SDL2/ "$SDK_NAME-$VERSION/aarch64-linux-gnu/include/"

if [[ $NO_COLOR = 1 ]]; then
  ./download_and_extract_debs.sh "$SDK_NAME-$VERSION/" --no-color
else
  ./download_and_extract_debs.sh "$SDK_NAME-$VERSION/"
fi

inform "Creating archive"
tar -cvJf "$SDK_NAME-$VERSION.tar.xz" "$SDK_NAME-$VERSION/"
