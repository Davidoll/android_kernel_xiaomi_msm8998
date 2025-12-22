#!/bin/bash

# Clean output directory
rm -rf out
mkdir -p out

# Architecture settings
export ARCH=arm64
export SUBARCH=arm64

# Toolchain paths
export CLANG_PATH=/android/RisingOS/prebuilts/clang/host/linux-x86/clang-r547379/bin/
export PATH=${CLANG_PATH}:${PATH}

# 64-bit cross compiler (for AArch64)
export CROSS_COMPILE=/home/linlinger/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-android-
# OR if you have GCC toolchain:
# export CROSS_COMPILE=/path/to/your/aarch64-gcc-toolchain/bin/aarch64-linux-android-

# 32-bit cross compiler (for ARM)
export CROSS_COMPILE_ARM32=/home/linlinger/android/toolchain/armhf-4.9/bin/arm-linux-androideabi-

# LLVM/Clang settings
export LLVM=1
export LLVM_IAS=1
export CC=clang
export LD=${CLANG_PATH}/ld.lld
export CLANG_TRIPLE=aarch64-linux-gnu-

echo "Configuring kernel..."
make O=out vendor/xiaomi/mi8998_defconfig

echo -e "\nBuilding kernel with $(nproc --all) threads..."
make O=out -j$(nproc --all)

# Optional: Verify the output
if [ -f "out/arch/arm64/boot/Image.gz-dtb" ]; then
    echo -e "\n✓ Build successful!"
    echo "Kernel image: out/arch/arm64/boot/Image.gz-dtb"
elif [ -f "out/arch/arm64/boot/Image.gz" ]; then
    echo -e "\n✓ Build successful!"
    echo "Kernel image: out/arch/arm64/boot/Image.gz"
else
    echo -e "\n✗ Build failed!"
    echo "Check for errors above."
fi
