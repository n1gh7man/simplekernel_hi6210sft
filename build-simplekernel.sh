#!/bin/bash

#
# Copyright © 2017, Paweł Hołownia "kosmitchak" <kosmitchak@gmail.com>
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it

# Init Script
LOCAL_DIR=`pwd`
ZIMAGE=$LOCAL_DIR/out/arch/arm64/boot/Image
BUILD_START=$(date +"%s")

# Color Code Script
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White
nocol='\033[0m'         # Default

# Standard GCC compiler
#export PATH=$PATH:$LOCAL_DIR/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin

# UberTC compiler
export PATH=$PATH:$LOCAL_DIR/prebuilts/aarch64-linux-android-4.9/bin

# Prepare to compile
export CROSS_COMPILE="aarch64-linux-android-"


# Compilation Scripts Are Below
compile_kernel ()
{
echo -e "$White***********************************************"
echo "               Compiling SimpleKernel              "
echo -e "***********************************************$nocol"
make ARCH=arm64 distclean
mkdir -p out
make ARCH=arm64 O=out hisi_hi6210sft_defconfig
make ARCH=arm64 O=out -j4
if ! [ -a $ZIMAGE ];
then
echo -e "$Red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
}

# Finalizing Script Below
case $1 in
clean)
make ARCH=arm64 distclean
;;
*)
compile_kernel
;;
esac
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$Yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
