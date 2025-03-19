# bl808_linux

bl808 Linux

## Environment Setup

### _Before doing anyything - clone this repo!_

Requirments:

    Ubuntu 20.04 - can be virtual machine or WSL

You weren't able to make firmware until you'll not prepare your system. 

It's simple as running 
    ./prepare.sh

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
make linux # - makes linux kernel (uncompressed)
make kcompress # - compress linux kernel (necessary for making system image)
make devicetree # - makes DTB (device tree blob from DTS)
make bootloader # - makes bootloader
make image # - makes image for flashing
make clean # - cleans build artifacts
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


