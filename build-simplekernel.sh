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

# FORMATS THE TIME
function format_time() {
    MINS=$(((${1} - ${2}) / 60))
    SECS=$(((${1} - ${2}) % 60))
    if [[ ${MINS} -ge 60 ]]; then
        HOURS=$((${MINS}/  60))
        MINS=$((${MINS} % 60))
    fi

    if [[ ${HOURS} -eq 1 ]]; then
        TIME_STRING+="1 HOUR, "
    elif [[ ${HOURS} -ge 2 ]]; then
        TIME_STRING+="${HOURS} HOURS, "
    fi

    if [[ ${MINS} -eq 1 ]]; then
        TIME_STRING+="1 MINUTE"
    else
        TIME_STRING+="${MINS} MINUTES"
    fi

    if [[ ${SECS} -eq 1 && -n ${HOURS} ]]; then
        TIME_STRING+=", AND 1 SECOND"
    elif [[ ${SECS} -eq 1 && -z ${HOURS} ]]; then
        TIME_STRING+=" AND 1 SECOND"
    elif [[ ${SECS} -ne 1 && -n ${HOURS} ]]; then
        TIME_STRING+=", AND ${SECS} SECONDS"
    elif [[ ${SECS} -ne 1 && -z ${HOURS} ]]; then
        TIME_STRING+=" AND ${SECS} SECONDS"
    fi

    echo ${TIME_STRING}
}

# Init Script
LOCAL_DIR=`pwd`
START=$(date +"%s")
FINAL_IMAGE=out/arch/arm64/boot/Image
MAKEFILE=Makefile

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


# UberTC compiler path
export PATH=$PATH:$LOCAL_DIR/prebuilts/aarch64-linux-android-4.9/bin

# Prepare to compile
export CROSS_COMPILE="aarch64-linux-android-"


# Compilation Scripts Are Below
compile_kernel ()
{
echo -e "$Cyan***********************************************"
echo "         *      Compiling SimpleKernel             * "
echo -e "***********************************************$nocol"
make ARCH=arm64 distclean
mkdir -p out
make ARCH=arm64 O=out hisi_hi6210sft_defconfig
make ARCH=arm64 O=out -j4
if ! [ -a $MAKEFILE ];
then
echo -e "$Red This must be run in a kernel tree! $nocol"
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
END=$(date +"%s")
[[ -f ${FINAL_IMAGE} ]] && echo "${GRN}BUILT IN $(format_time ${END} ${START})${RST}\n
${BOLD}IMAGE:${RST} ${FINAL_IMAGE}\n
${BOLD}VERSION:${RST} $(cat out/include/config/kernel.release)" \
                      || echo -e "$Red Kernel build failed! $nocol"
