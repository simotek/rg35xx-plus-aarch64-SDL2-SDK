# rg35xxplus-aarch64-SDL2-toolchain
This toolchain provides all the libraries available for compiling apps for the rg35xxplus handheld devices.

## Usage

## File Descriptions
* **setup.sh** - Setup the toolchain
* **SDL2/** - The SDL2 implementation on the device is different from the standard ubuntu one, all the headers are provided on the device so i've included the libs and headers here incase they are incompatible with the ubuntu ones.
* **clean.sh** - Basic clean script incase stuff goes wrong
* **download_and_extract_debs.sh** - Downloads all the required -dev .debs and there corrosponding libs, then add them to the correct location
* **package_list.txt** - The list of debs that need to be downloaded and extracted to build the toolchain / SDK
* **find_dev_packages.sh** - Run this on your rg35xx hardware to generate `package_list.txt`. To make life easier `package_list.txt` is included in this git repo so you shouldn't need to run it. You can use the `SSH Enabler` app found [here](https://github.com/exdial/anbernic-apps).
* **messages.sh** - Used to make things pretty, you don't need to know about this

## License
All the build scripts are licensed under the MIT License, everything else follows its existing license.
