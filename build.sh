#!/bin/bash
AK3_DIR="./AnyKernel3"
ZIPNAME="sagit-kernel-$(date +%Y%m%d-%H%M%S).zip"
# Clean output directory
rm -rf out
mkdir -p out

# Architecture settings
export ARCH=arm64
export SUBARCH=arm64

# Toolchain paths
export CLANG_PATH=/home/linlinger/toolchain/clang-rastamod/bin/
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

# Readme: to build for chirom ,replace sagit to chiron
echo "Configuring kernel..."
make O=out vendor/xiaomi/mi8998_sagit_defconfig

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
    exit 1
fi

# Generating AK3 zip

if [ -d "$AK3_DIR" ]; then
cp -r $AK3_DIR AnyKernel3
elif ! git clone https://github.com/davidoll/AnyKernel3 -b sagit; then
echo -e "\nAnyKernel3 repo not found locally and cloning failed! Aborting..."
exit 1
fi
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3
rm -f *zip
cd AnyKernel3
git checkout sagit &> /dev/null
zip -r9 "../$ZIPNAME" * -x '*.git*' README.md *placeholder
cd ..
rm -rf AnyKernel3
rm -rf out/arch/arm64/boot
