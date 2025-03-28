# makefile :)
PWDIR := $(shell pwd)
DEPS_DIR := $(PWDIR)/in
OUT_DIR := $(PWDIR)/out
CMAKE_DIR := $(PWDIR)/toolchain/cmake/bin/
LINUX_CROSS_PREFIX := $(PWDIR)/toolchain/linux_toolchain/bin/riscv64-unknown-linux-gnu-
ELF_CROSS_PREFIX := $(PWDIR)/toolchain/elf_newlib_toolchain/bin/riscv64-unknown-elf-
OPENSBI_DIR := $(PWDIR)/opensbi-0.6-808
OBJ_DIR := $(OUT_DIR)/obj
DTB_FILE := $(OUT_DIR)/hw.dtb.5M
DTS_FILE := $(PWDIR)/bl808_dts/hw808c.dts
OPENSBI_FILE := $(OUT_DIR)/fw_jump.bin
ROOTFS_FILE := $(DEPS_DIR)/squashfs_test.img
KERNEL_IMAGE_FILE := $(OUT_DIR)/Image.lz4
OUTPUT_BIN := $(OUT_DIR)/whole_img_linux.bin
BOOT_SRC := $(PWDIR)/bl_mcu_sdk_bl808/
FLASH_SIZE := $$(($(FLASH_MB) * 1024 * 1024))  # 7680*1024 - 335872
DTB_OFFSET = 0x00000000
OPENSBI_OFFSET = 0x00010000
KERNEL_OFFSET = 0x00020000
ROOTFS_OFFSET = 0x00480000

all: clean prepare opensbi linux devicetree bootloader image image

prepare:
	@mkdir -p $(OUT_DIR)
	@mkdir -p $(OBJ_DIR)

opensbi: prepare
	@cd $(OPENSBI_DIR) && make PLATFORM=thead/c910 CROSS_COMPILE=$(LINUX_CROSS_PREFIX) -j$(nproc)
	@cp $(OPENSBI_DIR)/build/platform/thead/c910/firmware/* $(OUT_DIR)/obj
	@cp $(OPENSBI_DIR)/build/platform/thead/c910/firmware/fw_jump.bin $(OUT_DIR)

menuconfig: prepare
	@cd $(PWDIR)/linux-5.10.4-808 && make ARCH=riscv CROSS_COMPILE=$(LINUX_CROSS_PREFIX) menuconfig -j$(nproc)

image: linux opensbi devicetree bootloader
	@cd $(OUT_DIR)
	@dd if=/dev/zero bs=1 count=$(FLASH_SIZE) | tr '\000' '\377' > $(OUTPUT_BIN)
	@dd if=$(DTB_FILE) of=$(OUTPUT_BIN) bs=1 seek=$(DTB_OFFSET) conv=notrunc
	@dd if=$(OPENSBI_FILE) of=$(OUTPUT_BIN) bs=1 seek=$(OPENSBI_OFFSET) conv=notrunc
	@dd if=$(KERNEL_IMAGE_FILE) of=$(OUTPUT_BIN) bs=1 seek=$(KERNEL_OFFSET) conv=notrunc
	@dd if=$(ROOTFS_FILE) of=$(OUTPUT_BIN) bs=1 seek=$(ROOTFS_OFFSET) conv=notrunc
	@echo "Image built: $(OUTPUT_BIN)"

devicetree: prepare
	@dtc -I dts -O dtb -o $(DTB_FILE) $(DTS_FILE)

bootloader: prepare
	@cd $(BOOT_SRC) && make CHIP=bl808 CPU_ID=m0 CMAKE_DIR=$(CMAKE_DIR) CROSS_COMPILE=$(ELF_CROSS_PREFIX) SUPPORT_DUALCORE=y APP=low_load clean
	@cd $(BOOT_SRC) && make CHIP=bl808 CPU_ID=m0 CMAKE_DIR=$(CMAKE_DIR) CROSS_COMPILE=$(ELF_CROSS_PREFIX) SUPPORT_DUALCORE=y APP=low_load && make CHIP=bl808 CPU_ID=d0 CMAKE_DIR=$(CMAKE_DIR) CROSS_COMPILE==$(ELF_CROSS_PREFIX) SUPPORT_DUALCORE=y APP=low_load
	@

clean:
	@rm -rfv $(OUT_DIR)
	@rm -rfv $(OPENSBI_DIR)/build
	@echo "Cleaned generated files."


.PHONY: all image clean