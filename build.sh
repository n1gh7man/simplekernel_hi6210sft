#!/bin/bash

LOCAL_DIR=`pwd`
export PATH=$PATH:$LOCAL_DIR/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin
export CROSS_COMPILE="aarch64-linux-android-"
mkdir -p out
echo "Paths and Toolchain loaded!"
make ARCH=arm64 O=out hisi_hi6210sft_defconfig
make ARCH=arm64 O=out -j4
printf "\nDone! Path to image: ../out/arch/arm64/boot/Image"
printf "\nThe Path modules out/(device)/*.ko\n"
