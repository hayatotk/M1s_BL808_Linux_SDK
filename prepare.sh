#!/usr/bin/env bash

rm -rfv toolchain
mkdir -p toolchain/cmake toolchain/elf_newlib_toolchain toolchain/linux_toolchain
curl https://cmake.org/files/v3.19/cmake-3.19.3-Linux-x86_64.tar.gz | tar xz -C toolchain/cmake/ --strip-components=1
curl https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1663142243961/Xuantie-900-gcc-elf-newlib-x86_64-V2.6.1-20220906.tar.gz | tar xz -C toolchain/elf_newlib_toolchain/ --strip-components=1
curl https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1663142514282/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1-20220906.tar.gz | tar xz -C toolchain/linux_toolchain/ --strip-components=1