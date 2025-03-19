#!/usr/bin/env bash
set -eu
echo "Checking and installing dependencies"
sudo apt update && sudo apt install -y gcc make flex bison libncurses-dev device-tree-compiler lz4 --no-install-recommends --no-install-suggests
echo "Installing BL808 SDK"
git submodule update --init --recursive
echo "Cleaning old toolchain if presented"
rm -rfv toolchain
echo "Initialising toolchain"
mkdir -p toolchain/cmake toolchain/elf_newlib_toolchain toolchain/linux_toolchain
curl https://cmake.org/files/v3.19/cmake-3.19.3-Linux-x86_64.tar.gz | tar xz -C toolchain/cmake/ --strip-components=1
curl https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1663142243961/Xuantie-900-gcc-elf-newlib-x86_64-V2.6.1-20220906.tar.gz | tar xz -C toolchain/elf_newlib_toolchain/ --strip-components=1
curl https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1663142514282/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1-20220906.tar.gz | tar xz -C toolchain/linux_toolchain/ --strip-components=1
echo "Patching makefile"
mv ./Makefile.obj ./Makefile
echo "Done!"
exit 0