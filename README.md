# rg35xxplus-aarch64-SDL2-toolchain
This toolchain provides all the libraries available for compiling apps for the rg35xx-plus handheld devices.

This repo fetches and provides all the header files that are present on the rg35xx-plus and there corresponding libraries along with a compatible (Same Version) of the gcc compiler. If an SDL 2 based application compiles against this SDK it should run on the rg35xx-plus and maybe other similar devices.

The devices currently runs Ubuntu 22.04 (Jammy Jellyfish), it is possible to install additional packages using `apt` without too much effort but there are some limitations. The display system seems to be based around a modified version of the SDL2 libraries, to date I have not been able to get a non SDL2 graphical application to display on the screen while SDL2 based apps seem fine.

## Usage
A sample makefile may include the following.

```
DEVKIT := <path to SDK>/rg35xx-plus-aarch64-SDL2-SDK-0.1.0/
CROSS_COMPILE:=$(DEVKIT)bin/aarch64-none-linux-gnu-
TRIPLET:=aarch64-linux-gnu
CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
TOOLPATH=$(DEVKIT)/usr/bin
OPT_FLAGS = -O3 -mlittle-endian -mabi=lp64 -march=armv8-a+crypto+crc -fasynchronous-unwind-tables -fstack-protector-strong -Wformat -Wformat-security -fstack-clash-protection -dumpbase 
INCLUDES = -Iinclude $(SDL_CFLAGS) -I$(DEVKIT)/$(TRIPLET)/include -I$(DEVKIT)/$(TRIPLET)/include/c++/11/ -I$(PWD)/../sources -D_REENTRANT
CFLAGS	:=	$(DEFINES) $(INCLUDES) $(OPT_FLAGS) -Wall  
CXXFLAGS:=	$(CFLAGS) -std=gnu++03 
LIBS	:= -Wl,-rpath-link,$(DEVKIT)/$(TRIPLET)/lib -Wl,-rpath-link,$(DEVKIT)/$(TRIPLET)/lib/pulseaudio -lSDL2 -lpthread
```

## File Descriptions
* **setup.sh** - Setup the toolchain
* **SDL2/** - The SDL2 implementation on the device is different from the standard ubuntu one, all the headers are provided on the device so i've included the libs and headers here incase they are incompatible with the ubuntu ones.
* **clean.sh** - Basic clean script incase stuff goes wrong
* **download_and_extract_debs.sh** - Downloads all the required -dev .debs and there corresponding libs, then add them to the correct location
* **package_list.txt** - The list of debs that need to be downloaded and extracted to build the toolchain / SDK
* **find_dev_packages.sh** - Run this on your rg35xx hardware to generate `package_list.txt`. To make life easier `package_list.txt` is included in this git repo so you shouldn't need to run it. You can use the `SSH Enabler` app found [here](https://github.com/exdial/anbernic-apps).
* **messages.sh** - Used to make things pretty, you don't need to know about this

## License
All the build scripts are licensed under the MIT License, everything else follows its existing license.
