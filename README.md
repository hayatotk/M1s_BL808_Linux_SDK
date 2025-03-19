# bl808_linux

bl808 Linux

```bash
.
├── bl808_dts         # kernel dts file
├── bl_mcu_sdk_bl808  # bl_mcu_sdk for build low load bin
├── build.sh          # build script
├── linux-5.10.4-808  # linux kernel code
├── opensbi-0.6-808   # opensbi code
├── out               # bin file output dir
├── toolchain         # build need toolchain
└── README.md         # readme file
```

## Environment Setup

### _Before doing anyything - clone this repo!_

Requirments:

    Ubuntu 20.04 - can be virtual machine or WSL

Ubuntu20.04 needs to use apt to install the package:

```bash
sudo apt update && sudo apt install -y gcc make flex bison libncurses-dev device-tree-compiler lz4 --no-install-recommends --no-install-suggests
```

Download toolchains

```bash
mkdir -p M1s_BL808_Linux_SDK/toolchain/{cmake,elf_newlib_toolchain,linux_toolchain} && curl -L https://cmake.org/files/v3.19/cmake-3.19.3-Linux-x86_64.tar.gz | tar xz -C M1s_BL808_Linux_SDK/toolchain/cmake --strip-components=1 && curl -L https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1663142243961/Xuantie-900-gcc-elf-newlib-x86_64-V2.6.1-20220906.tar.gz | tar xz -C M1s_BL808_Linux_SDK/toolchain/elf_newlib_toolchain --strip-components=1 && curl -L https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1663142514282/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1-20220906.tar.gz | tar xz -C M1s_BL808_Linux_SDK/toolchain/linux_toolchain --strip-components=1

```

## Compile

The simpliest way to compile is just running 

```bash
make
```

it works in the similar way as `build.sh` but it is compatible with most of CI/CDs and IDEs (like vscode or clion) and have similar syntax

```bash
make all # - cleans, then builds all targets below (w/o menuconfig)
make opensbi # - builds openSBI (HAL-like blobs for running linux on rv)
make menuconfig # - tui kernel configurator. If you know what is this - you know what is this
make linux # - makes linux kernel
make devicetree # - makes DTB (device tree blob from DTS)
make bootloader # - makes bootloader
make image # - makes image for flashing
make clean # - cleans build artifacts
```


otherwise you can use build.sh script

Step by step

```bash
./build.sh --help
./build.sh opensbi
./build.sh kernel_config # generally it's a 'kmenuconfig'. Do everything on your own risk!
./build.sh kernel
./build.sh dtb
./build.sh low_load
./build.sh whole_bin
```

Or

```bash
./build.sh all
```

Then find the firmwares under out

```bash
├── fw_jump.bin
├── hw.dtb.5M
├── Image.lz4
├── squashfs_test.img 
├── low_load_bl808_d0.bin 
├── low_load_bl808_m0.bin 
├── merge_7_5Mbin.py
└── whole_img_linux.bin
```

## Download Firmware

- Get the latest version of DevCube from http://dev.bouffalolab.com/download
- Connect BL808 board with PC by USB cable
- Set BL808 board to programming mode
    + Press BOOT button
    + Press RESET button
    + Release RESET button
    + Release BOOT button
- Run DevCube, select [BL808], and switch to [MCU] page
- Select the uart port and set baudrate with 2000000
- M0 Group[Group0] Image Addr [0x58000000] [PATH to low_load_bl808_m0.bin]
- D0 Group[Group1] Image Addr [0x58000000] [PATH to low_load_bl808_d0.bin]
- Click 'Create & Download' and wait until it's done
- Switch to [IOT] page
- Enable 'Single Download', set Address with 0xD2000, choose [PATH to whole_image_linux.bin]
- Click 'Create & Download' again and wait until it's done

## Boot BL808 board

Press and release RESET button, E907 will output log by IO14(TX)/IO15(RX) and C906 by IO5(RX)/IO8(TX)

## WSL Support - Windows Subsystem for linux


