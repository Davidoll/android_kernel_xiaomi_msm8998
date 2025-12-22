#!/bin/bash

rm -rf out
mkdir -p out
export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=/android/RisingOS/prebuilts/clang/host/linux-x86/clang-r547379/bin/
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=/home/linlinger/android/toolchain/armhf-4.9/bin/arm-linux-androideabi-
export CLANG_TRIPLE=/home/linlinger/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-
export LD=${CLANG_PATH}/ld.lld

echo "Config"
make CC=clang O=out vendor/xiaomi/mi8998_defconfig

echo "Building kernel"
echo 

make CC=clang LLVM=1 LLVM_IAS=1 O=out -j$(nproc --all)

